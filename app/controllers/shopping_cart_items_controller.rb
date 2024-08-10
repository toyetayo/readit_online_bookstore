class ShoppingCartItemsController < ApplicationController
  before_action :authenticate_user!, except: %i[index create update destroy]
  before_action :set_shopping_cart_item, only: %i[update destroy]

  def index
    @shopping_cart_items = if user_signed_in?
                             current_user.shopping_cart_items.includes(:product)
                           else
                             session[:shopping_cart] ||= []
                             session[:shopping_cart].map { |item| OpenStruct.new(item) }
                           end
  end

  def create
    if user_signed_in?
      @shopping_cart_item = current_user.shopping_cart_items
                                        .find_or_initialize_by(
                                          product_id: shopping_cart_item_params[:product_id]
                                        )
      @shopping_cart_item.quantity = if @shopping_cart_item.new_record?
                                       shopping_cart_item_params[:quantity].to_i
                                     else
                                       @shopping_cart_item.quantity +
                                         shopping_cart_item_params[:quantity].to_i
                                     end

      if @shopping_cart_item.save
        redirect_to shopping_cart_items_path, notice: 'Item added to cart.'
      else
        redirect_to products_path, alert: 'Unable to add item to cart.'
      end
    else
      add_to_session_cart(shopping_cart_item_params)
      redirect_to shopping_cart_items_path, notice: 'Item added to cart.'
    end
  end

  def update
    if user_signed_in?
      Rails.logger.debug "Updating cart item: #{shopping_cart_item_params.inspect}"
      if @shopping_cart_item.update(shopping_cart_item_params)
        redirect_to shopping_cart_items_path, notice: 'Cart updated.'
      else
        Rails.logger.debug "Failed to update cart item: #{@shopping_cart_item.errors.full_messages}"
        redirect_to shopping_cart_items_path, alert: 'Unable to update cart.'
      end
    else
      Rails.logger.debug "Updating session cart item: #{shopping_cart_item_params.inspect}"
      update_session_cart(shopping_cart_item_params)
      redirect_to shopping_cart_items_path, notice: 'Cart updated.'
    end
  end

  def destroy
    if user_signed_in?
      Rails.logger.debug "Destroying cart item: #{@shopping_cart_item.inspect}"
      @shopping_cart_item.destroy
    else
      product_id = params[:id].to_i
      Rails.logger.debug "Destroying session cart item with product_id: #{product_id}"
      session[:shopping_cart].reject! { |item| item['product_id'] == product_id }
    end
    redirect_to shopping_cart_items_path, notice: 'Item removed from cart.'
  end

  private

  def shopping_cart_item_params
    params.require(:shopping_cart_item).permit(:product_id, :quantity)
  end

  def add_to_session_cart(item_params)
    session[:shopping_cart] ||= []
    existing_item = session[:shopping_cart].find do |item|
      item['product_id'] == item_params[:product_id].to_i
    end
    if existing_item
      existing_item['quantity'] += item_params[:quantity].to_i
    else
      session[:shopping_cart] << item_params.to_h
    end
  end

  def update_session_cart(item_params)
    session[:shopping_cart].each do |item|
      if item['product_id'] == item_params[:product_id].to_i
        item['quantity'] = item_params[:quantity].to_i
      end
    end
  end

  def set_shopping_cart_item
    if user_signed_in?
      @shopping_cart_item = current_user.shopping_cart_items.find(params[:id])
      Rails.logger.debug "Set cart item: #{@shopping_cart_item.inspect}"
    else
      session[:shopping_cart] ||= []
      item = session[:shopping_cart].find { |i| i['product_id'] == params[:id].to_i }
      @shopping_cart_item = OpenStruct.new(item) if item
      Rails.logger.debug "Set cart item: #{@shopping_cart_item.inspect}" if @shopping_cart_item
    end
  end
end
