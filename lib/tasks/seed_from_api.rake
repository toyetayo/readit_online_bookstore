require 'httparty'

namespace :db do
  desc 'Fetch book data from Open Library API and seed the database'
  task seed_from_api: :environment do
    # Clear existing data
    ProductCategory.destroy_all
    Product.destroy_all
    Category.destroy_all

    base_url = 'https://openlibrary.org/search.json?q='
    query = 'fiction' # You can modify the query to fetch different books
    url = "#{base_url}#{query}"

    response = HTTParty.get(url)
    books_data = response.parsed_response['docs']

    categories = books_data.map { |book| book['subject'] }.flatten.compact.uniq

    # Seed categories
    categories.each do |category_name|
      Category.find_or_create_by!(name: category_name)
    end

    # Seed products
    books_data.each do |book_data|
      next if book_data['title'].blank? || book_data['author_name'].blank?

      category_names = book_data['subject'] || ['Uncategorized']
      associated_categories = Category.where(name: category_names)

      product = Product.create!(
        name: book_data['title'],
        author: book_data['author_name'].first,
        description: book_data['first_sentence'] || 'No description available',
        price: rand(10.0..100.0).round(2), # Random price since API does not provide it
        number_in_stock: rand(1..100),
        user: User.find_by(email: 'user@readitapp.com') # Assuming a default user
      )

      associated_categories.each do |category|
        ProductCategory.create!(product:, category:)
      end
    end

    puts "Seeded #{Product.count} products and #{Category.count} categories."
  end
end
