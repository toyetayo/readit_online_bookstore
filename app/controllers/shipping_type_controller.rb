# app/controllers/shipping_types_controller.rb
class ShippingTypesController < ApplicationController
  def price
    shipping_type = ShippingType.find(params[:id])
    render json: { price: shipping_type.price }
  end
end
