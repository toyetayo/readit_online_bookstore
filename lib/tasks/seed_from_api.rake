require 'httparty'
require 'open-uri'

namespace :db do
  desc 'Fetch book data from Open Library API and seed the database'
  task seed_from_api: :environment do
    base_url = 'https://openlibrary.org/search.json?q='
    query = 'fiction' # You can modify the query to fetch different books
    url = "#{base_url}#{query}&limit=100" # Limit the number of books fetched

    response = HTTParty.get(url)
    books_data = response.parsed_response['docs']

    categories_with_products = {}
    products_without_author = []
    products_without_image = []

    # Process the book data
    books_data.each do |book_data|
      if book_data['title'].blank? || book_data['author_name'].blank? || book_data['cover_i'].blank?
        next
      end

      category_names = book_data['subject'] || ['Uncategorized']
      category_names.each do |category_name|
        categories_with_products[category_name] ||= []
        if categories_with_products[category_name].size < 2
          categories_with_products[category_name] << book_data
        end
      end
    end

    # Ensure no more than 50 categories with at least 2 products
    categories_with_products = categories_with_products.select do |_, books|
      books.size >= 2
    end.take(50).to_h

    # Seed categories and products
    categories_with_products.each do |category_name, books|
      category = Category.create!(name: category_name)
      books.each do |book_data|
        product = Product.create!(
          name:            book_data['title'],
          author:          book_data['author_name'].first,
          description:     book_data['first_sentence'] || 'No description available',
          price:           rand(10.0..100.0).round(2), # Random price since API does not provide it
          number_in_stock: rand(1..100),
          category:
        )
        ProductCategory.create!(product:, category:)

        # Attach image
        image_url = "https://covers.openlibrary.org/b/id/#{book_data['cover_i']}-L.jpg"
        begin
          product.image.attach(io: URI.open(image_url), filename: "#{book_data['cover_i']}.jpg")
        rescue StandardError => e
          puts "Failed to attach image for product #{product.name}: #{e.message}"
          products_without_image << product.name
        end
      end
    end

    puts "Seeded #{Product.count} products and #{Category.count} categories."
    unless products_without_author.empty?
      puts "Products without author: #{products_without_author.join(', ')}"
    end
    unless products_without_image.empty?
      puts "Products without image: #{products_without_image.join(', ')}"
    end
  end
end
