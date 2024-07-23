class OrdersController < ApplicationController
  before_action :authenticate_user!

  def new
    @order = current_user.orders.build
    @shopping_cart_items = current_user.shopping_cart_items.includes(:product)
  end

  def create
    @order = current_user.orders.build(order_params)
    @order.status = 'new'
    if @order.save
      process_order_items
      current_user.shopping_cart_items.destroy_all
      redirect_to @order, notice: 'Order placed successfully.'
    else
      @shopping_cart_items = current_user.shopping_cart_items.includes(:product)
      render :new
    end
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  def past_orders
    @orders = current_user.orders.page(params[:page])
  end

  private

  def order_params
    params.require(:order).permit(:receiver_name, :address, :city, :zip, :province_id, :shipping_type_id)
  end

  def process_order_items
    current_user.shopping_cart_items.each do |cart_item|
      @order.order_items.create!(
        product: cart_item.product,
        quantity: cart_item.quantity,
        price: cart_item.product.price
      )
    end
    calculate_total
  end

  def calculate_total
    tax_rates = @order.province.slice(:pst_rate, :gst_rate, :hst_rate).values.compact
    subtotal = @order.order_items.sum('quantity * price')
    total_tax = tax_rates.sum { |rate| subtotal * rate }
    @order.update(total_price: subtotal + total_tax)
  end
end
