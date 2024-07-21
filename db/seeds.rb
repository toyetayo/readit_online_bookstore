# db/seeds.rb

# Ensure the existence of an admin user
AdminUser.find_or_create_by!(email: 'admin@readitapp.com') do |admin|
  admin.password = 'password'
  admin.password_confirmation = 'password'
end

# Create a default user for associating products
default_user = User.find_or_create_by!(email: 'user@readitapp.com') do |user|
  user.password = 'password'
  user.password_confirmation = 'password'
end

# Create product records
10.times do
  Product.create!(
    name: Faker::Book.title,
    author: Faker::Book.author,
    number_in_stock: Faker::Number.between(from: 1, to: 100),
    price: Faker::Commerce.price(range: 10.0..100.0),
    description: Faker::Lorem.paragraph,
    user: default_user
  )
end

puts 'Seeding completed successfully!'
