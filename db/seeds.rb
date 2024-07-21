require 'faker'
require 'open-uri'

puts 'Starting seeding process...'

# Clear existing data (optional, but useful for resetting during development)
ProductCategory.destroy_all
Product.destroy_all
Category.destroy_all
User.destroy_all
Province.destroy_all

# Ensure the existence of an admin user
AdminUser.find_or_create_by!(email: 'admin@readitapp.com') do |admin|
  admin.password = 'password'
  admin.password_confirmation = 'password'
end

# Create Canadian provinces
puts 'Seeding Canadian provinces...'
provinces = [
  { id: 'NL', name: 'Newfoundland and Labrador', gst_rate: 0.0, pst_rate: 0.0, hst_rate: 0.15, qst_rate: 0.0 },
  { id: 'PE', name: 'Prince Edward Island', gst_rate: 0.0, pst_rate: 0.0, hst_rate: 0.15, qst_rate: 0.0 },
  { id: 'NS', name: 'Nova Scotia', gst_rate: 0.0, pst_rate: 0.0, hst_rate: 0.15, qst_rate: 0.0 },
  { id: 'NB', name: 'New Brunswick', gst_rate: 0.0, pst_rate: 0.0, hst_rate: 0.15, qst_rate: 0.0 },
  { id: 'QC', name: 'Quebec', gst_rate: 0.05, pst_rate: 0.0, hst_rate: 0.0, qst_rate: 0.09975 },
  { id: 'ON', name: 'Ontario', gst_rate: 0.0, pst_rate: 0.0, hst_rate: 0.13, qst_rate: 0.0 },
  { id: 'MB', name: 'Manitoba', gst_rate: 0.05, pst_rate: 0.07, hst_rate: 0.0, qst_rate: 0.0 },
  { id: 'SK', name: 'Saskatchewan', gst_rate: 0.05, pst_rate: 0.06, hst_rate: 0.0, qst_rate: 0.0 },
  { id: 'AB', name: 'Alberta', gst_rate: 0.05, pst_rate: 0.0, hst_rate: 0.0, qst_rate: 0.0 },
  { id: 'BC', name: 'British Columbia', gst_rate: 0.05, pst_rate: 0.07, hst_rate: 0.0, qst_rate: 0.0 },
  { id: 'YT', name: 'Yukon', gst_rate: 0.05, pst_rate: 0.0, hst_rate: 0.0, qst_rate: 0.0 },
  { id: 'NT', name: 'Northwest Territories', gst_rate: 0.05, pst_rate: 0.0, hst_rate: 0.0, qst_rate: 0.0 },
  { id: 'NU', name: 'Nunavut', gst_rate: 0.05, pst_rate: 0.0, hst_rate: 0.0, qst_rate: 0.0 }
]
provinces.each do |province|
  Province.find_or_create_by!(province)
end
puts "Provinces seeded: #{Province.count}"

# Create a default user for associating products
default_user = User.find_or_create_by!(email: 'user@readitapp.com') do |user|
  user.password = 'password'
  user.password_confirmation = 'password'
  user.first_name = Faker::Name.first_name
  user.last_name = Faker::Name.last_name
  user.address = Faker::Address.street_address
  user.city = Faker::Address.city
  user.zip = Faker::Address.zip_code
  user.phone_number = Faker::PhoneNumber.phone_number
  user.province_id = Province.all.sample.id
end

# Seed users
puts 'Seeding users...'
10.times do
  province = Province.all.sample
  User.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    address: Faker::Address.street_address,
    city: Faker::Address.city,
    zip: Faker::Address.zip_code,
    email: Faker::Internet.email,
    phone_number: Faker::PhoneNumber.phone_number,
    province_id: province.id,
    password: 'password',
    password_confirmation: 'password'
  )
  puts "Created user with province: #{province.name}"
rescue ActiveRecord::RecordInvalid => e
  puts "Error creating user: #{e.message}"
end

# Seed categories
puts 'Seeding categories...'
categories = ['Fiction', 'Non-fiction', 'Science Fiction', 'Fantasy']
categories.each do |category_name|
  Category.find_or_create_by!(name: category_name)
end
puts "Seeded #{Category.count} categories."

# Seed products with Faker and associated images
puts 'Seeding products...'
100.times do |i|
  category = Category.all.sample
  product = Product.create!(
    name: Faker::Book.title,
    author: Faker::Book.author,
    description: Faker::Lorem.paragraph(sentence_count: 5),
    price: Faker::Commerce.price(range: 10.0..100.0),
    number_in_stock: Faker::Number.between(from: 1, to: 100),
    user: default_user
  )
  ProductCategory.create!(product:, category:)
  puts "Created product #{i + 1}: #{product.name} with category: #{category.name}"

  # Attach a sample image to the product (using a placeholder image service)
  retries = 3
  begin
    file = URI.open('https://via.placeholder.com/150')
    product.image.attach(io: file, filename: "#{product.name.parameterize}.jpg")
  rescue OpenURI::HTTPError => e
    retries -= 1
    if retries > 0
      puts "Retrying image download for product #{i + 1} due to error: #{e.message}"
      retry
    else
      puts "Failed to attach image for product #{i + 1} after multiple attempts: #{e.message}"
    end
  end
rescue ActiveRecord::RecordInvalid => e
  puts "Error creating product #{i + 1}: #{e.message}"
end
puts "Seeded #{Product.count} products."

puts 'Database seeding with custom data completed!'
