require 'faker'
require 'open-uri'

Rails.logger.debug 'Starting seeding process...'

# Clear existing data in the correct order to avoid foreign key constraints
OrderItem.destroy_all
ShoppingCartItem.destroy_all
ProductReview.destroy_all
Order.destroy_all
Product.destroy_all
Category.destroy_all
User.destroy_all
Province.destroy_all
ShippingType.destroy_all

# Ensure the existence of an admin user
AdminUser.find_or_create_by!(email: 'admin@readitapp.com') do |admin|
  admin.password = 'password'
  admin.password_confirmation = 'password'
end

# Seed Canadian provinces
Rails.logger.debug 'Seeding Canadian provinces...'
provinces = [
  { id: 'NL', name: 'Newfoundland and Labrador', gst_rate: 0.0, pst_rate: 0.0, hst_rate: 0.15,
    qst_rate: 0.0 },
  { id: 'PE', name: 'Prince Edward Island', gst_rate: 0.0, pst_rate: 0.0, hst_rate: 0.15,
    qst_rate: 0.0 },
  { id: 'NS', name: 'Nova Scotia', gst_rate: 0.0, pst_rate: 0.0, hst_rate: 0.15, qst_rate: 0.0 },
  { id: 'NB', name: 'New Brunswick', gst_rate: 0.0, pst_rate: 0.0, hst_rate: 0.15, qst_rate: 0.0 },
  { id: 'QC', name: 'Quebec', gst_rate: 0.05, pst_rate: 0.0, hst_rate: 0.0, qst_rate: 0.09975 },
  { id: 'ON', name: 'Ontario', gst_rate: 0.0, pst_rate: 0.0, hst_rate: 0.13, qst_rate: 0.0 },
  { id: 'MB', name: 'Manitoba', gst_rate: 0.05, pst_rate: 0.07, hst_rate: 0.0, qst_rate: 0.0 },
  { id: 'SK', name: 'Saskatchewan', gst_rate: 0.05, pst_rate: 0.06, hst_rate: 0.0, qst_rate: 0.0 },
  { id: 'AB', name: 'Alberta', gst_rate: 0.05, pst_rate: 0.0, hst_rate: 0.0, qst_rate: 0.0 },
  { id: 'BC', name: 'British Columbia', gst_rate: 0.05, pst_rate: 0.07, hst_rate: 0.0,
    qst_rate: 0.0 },
  { id: 'YT', name: 'Yukon', gst_rate: 0.05, pst_rate: 0.0, hst_rate: 0.0, qst_rate: 0.0 },
  { id: 'NT', name: 'Northwest Territories', gst_rate: 0.05, pst_rate: 0.0, hst_rate: 0.0,
    qst_rate: 0.0 },
  { id: 'NU', name: 'Nunavut', gst_rate: 0.05, pst_rate: 0.0, hst_rate: 0.0, qst_rate: 0.0 }
]
provinces.each do |province|
  Province.find_or_create_by!(province)
end
Rails.logger.debug "Provinces seeded: #{Province.count}"

# Seed Shipping Types
Rails.logger.debug 'Seeding shipping types...'
shipping_types = [
  { name: 'Standard', price: 5.00, delivery_days: 5 },
  { name: 'Express', price: 15.00, delivery_days: 2 },
  { name: 'Overnight', price: 25.00, delivery_days: 1 }
]
shipping_types.each do |shipping_type|
  ShippingType.find_or_create_by!(shipping_type)
end
Rails.logger.debug "Seeded #{ShippingType.count} shipping types."

# Create a default user for associating products
default_user = User.find_or_create_by!(email: 'user@readitapp.com') do |user|
  user.password = 'password'
  user.password_confirmation = 'password'
  user.username = Faker::Internet.username
  user.first_name = Faker::Name.first_name
  user.last_name = Faker::Name.last_name
  user.address = Faker::Address.street_address
  user.city = Faker::Address.city
  user.zip = Faker::Address.zip_code
  user.phone_number = Faker::PhoneNumber.phone_number
  user.province_id = Province.all.sample.id
end

# Seed categories
Rails.logger.debug 'Seeding categories...'
categories = ['Fiction', 'Non-fiction', 'Science Fiction', 'Fantasy']
categories.each do |category_name|
  Category.find_or_create_by!(name: category_name)
end
Rails.logger.debug "Seeded #{Category.count} categories."

# Seed users
Rails.logger.debug 'Seeding users...'
10.times do
  province = Province.all.sample
  User.create!(
    first_name:            Faker::Name.first_name,
    last_name:             Faker::Name.last_name,
    address:               Faker::Address.street_address,
    city:                  Faker::Address.city,
    zip:                   Faker::Address.zip_code,
    email:                 Faker::Internet.email,
    phone_number:          Faker::PhoneNumber.phone_number,
    province_id:           province.id,
    username:              Faker::Internet.username,
    password:              'password',
    password_confirmation: 'password'
  )
  Rails.logger.debug "Created user with province: #{province.name}"
rescue ActiveRecord::RecordInvalid => e
  Rails.logger.debug "Error creating user: #{e.message}"
end

# Seed products with Faker and associated images
Rails.logger.debug 'Seeding products...'
100.times do |i|
  category = Category.all.sample
  product = Product.create!(
    name:            Faker::Book.title,
    author:          Faker::Book.author,
    description:     Faker::Lorem.paragraph(sentence_count: 5),
    price:           Faker::Commerce.price(range: 10.0..100.0),
    number_in_stock: Faker::Number.between(from: 1, to: 100),
    category_id:     category.id
  )
  Rails.logger.debug "Created product #{i + 1}: #{product.name}"

  # Attach a sample image to the product (using a placeholder image service)
  retries = 3
  begin
    file = URI.open('https://via.placeholder.com/150')
    product.image.attach(io: file, filename: "#{product.name}.jpg")
  rescue StandardError => e
    Rails.logger.debug "Failed to attach image for product #{product.name}. Retrying..."
    retries -= 1
    retry if retries > 0
  end
end
Rails.logger.debug "Seeded #{Product.count} products."

# Create pages for About Us and Contact Us
Rails.logger.debug 'Seeding pages...'
Page.find_or_create_by!(slug: 'about') do |page|
  page.title = 'About Us'
  page.content = 'This is the about page content.'
end

Page.find_or_create_by!(slug: 'contact') do |page|
  page.title = 'Contact Us'
  page.content = 'This is the contact page content.'
end

Rails.logger.debug "Seeded pages: #{Page.count}"

Rails.logger.debug 'Seeding process completed.'
