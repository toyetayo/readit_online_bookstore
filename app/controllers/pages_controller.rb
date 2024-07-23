class ProductsController < ApplicationController
  def index
    @categories = Category.page(params[:category_page])
    @products = Product.with_attached_image

    if params[:search].present?
      keyword = params[:search][:keyword]
      category_id = params[:search][:category_id]

      @products = if category_id.present?
                    @products.where(category_id:).where('name LIKE ? OR description LIKE ?',
                                                        "%#{keyword}%", "%#{keyword}%")
                  else
                    @products.where('name LIKE ? OR description LIKE ?', "%#{keyword}%", "%#{keyword}%")
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
      end
    end

    @products = @products.offset(50).page(params[:page])

    Rails.logger.debug("Loaded Products: #{@products.map(&:name).inspect}")
  end

  def show
    @product = Product.find(params[:id])
    @related_products = Product.where(category_id: @product.category_id).where.not(id: @product.id).with_attached_image.limit(4)
  end
end
