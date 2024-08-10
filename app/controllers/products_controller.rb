class ProductsController < ApplicationController
  def index
    @categories = Category.joins(:products).distinct.page(params[:category_page])
    @products = Product.with_attached_image

    if params[:search].present?
      keyword = params[:search][:keyword]
      category_id = params[:search][:category_id]

      @products = if category_id.present?
                    @products.search_by_category(keyword, category_id)
                  else
                    @products.search_by_keyword(keyword)
                  end
    end

    if params[:filter].present?
      case params[:filter]
      when 'on_sale'
        @products = @products.on_sale
      when 'new'
        @products = @products.new_products
      when 'recently_updated'
        @products = @products.recently_updated
        Rails.logger.debug("Recently Updated Products: #{@products.pluck(:updated_at, :name).inspect}")
      end
    end

    if params[:category_id].present?
      @selected_category = Category.find(params[:category_id])
      @products = @products.where(category_id: @selected_category.id)
    end

    @products = @products.page(params[:page])
  end

  def show
    @product = Product.find(params[:id])
    @related_products = Product.where(category_id: @product.category_id)
                               .where.not(id: @product.id)
                               .with_attached_image
                               .limit(4)
  end
end
