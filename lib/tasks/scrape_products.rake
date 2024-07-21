require 'nokogiri'
require 'typhoeus'
require 'open-uri'
require 'logger'

namespace :db do
  task scrape_products: :environment do
    base_url = 'https://books.toscrape.com'
    catalog_url = '/catalogue/'
    page_url = 'https://books.toscrape.com/catalogue/page-1.html'
    products = []
    categories = []
    hydra = Typhoeus::Hydra.new(max_concurrency: 20)
    logger = Logger.new(STDOUT)
    logger.level = Logger::INFO

    while page_url
      logger.info "Scraping page: #{page_url}"
      response = Typhoeus.get(page_url)
      parsed_page = Nokogiri::HTML(response.body)

      parsed_page.css('.product_pod').each do |product_item|
        product_url = product_item.css('h3 a').attr('href').value
        full_product_url = URI.join(base_url, catalog_url, product_url).to_s

        request = Typhoeus::Request.new(full_product_url)
        request.on_complete do |response|
          product_parsed_page = Nokogiri::HTML(response.body)

          # Correctly extract the image URL
          image_url = product_parsed_page.at_css('#product_gallery img').attr('src')
          image_url = URI.join(base_url, image_url).to_s

          # Extract author name from the table below product description
          author = product_parsed_page.css('table tr')[2].css('td').text

          product = {
            title: product_parsed_page.css('h1').text,
            author:,
            description: product_parsed_page.at_css('#product_description + p')&.text || 'No description available',
            price: product_parsed_page.css('.price_color').text.gsub('£', '').to_f,
            category: product_parsed_page.css('.breadcrumb li:nth-child(3) a').text,
            image_url:
          }
          products << product
          categories << product[:category] unless categories.include?(product[:category])
        end

        hydra.queue(request)
      end

      next_page = parsed_page.css('.next a').attr('href')
      page_url = next_page ? URI.join(base_url, catalog_url, next_page.value).to_s : nil
    end

    hydra.run

    # Seed categories
    categories.each do |category_name|
      Category.find_or_create_by!(name: category_name)
    end

    # Seed products and attach images
    products.each do |product_data|
      category = Category.find_by(name: product_data[:category])
      product = Product.create!(
        name: product_data[:title],
        author: product_data[:author],
        description: product_data[:description],
        price: product_data[:price],
        number_in_stock: rand(1..100),
        user: User.find_by(email: 'user@readitapp.com') # Assuming a default user
      )

      ProductCategory.create!(product:, category:)

      # Attach the image using Active Storage
      begin
        logger.info "Attaching image for #{product_data[:title]} from #{product_data[:image_url]}"
        image_file = URI.open(product_data[:image_url])
        product.image.attach(io: image_file, filename: File.basename(URI.parse(product_data[:image_url]).path))
        logger.info "Image attached: #{product.image.attached?}"
      rescue OpenURI::HTTPError => e
        logger.error "Failed to attach image for #{product_data[:title]}: #{e.message}"
      rescue StandardError => e
        logger.error "An error occurred while attaching image for #{product_data[:title]}: #{e.message}"
      end
    end

    logger.info "Scraped and seeded #{products.count} products and #{categories.count} categories."
  end
end
