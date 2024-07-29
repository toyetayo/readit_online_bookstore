class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_stripe_api_key

  def index
    @orders = current_user.orders.includes(:order_items, :province)
  end

  def new
    @order = Order.new
    @shopping_cart_items = current_user.shopping_cart_items
    @shopping_cart_total = @shopping_cart_items.sum { |item| item.product.price * item.quantity }
    calculate_taxes
  end

  def create
    @shopping_cart_items = current_user.shopping_cart_items

    if @shopping_cart_items.empty?
      redirect_to shopping_cart_items_path,
                  alert: 'Kindly select products to add to your shopping cart before placing an order.'
      return
    end

    @order = Order.new(order_params)
    @order.user = current_user
    @order.status = 'pending'
    @order.subtotal = @shopping_cart_items.sum { |item| item.product.price * item.quantity }
    @shopping_cart_total = @order.subtotal

    province = current_user.province
    @order.gst_rate = province.gst_rate
    @order.pst_rate = province.pst_rate
    @order.hst_rate = province.hst_rate
    @order.qst_rate = province.qst_rate

    calculate_taxes
    @order.total_price = @order.subtotal + @gst + @pst + @hst + @qst

    if @order.save
      @shopping_cart_items.each do |item|
        @order.order_items.create(product: item.product, quantity: item.quantity, price: item.product.price,
                                  product_price: item.product.price)
      end
      current_user.shopping_cart_items.destroy_all

      begin
        payment_intent = Stripe::PaymentIntent.create({
                                                        amount: (@order.total_price * 100).to_i,
                                                        currency: 'usd',
                                                        payment_method: params[:payment_method_id],
                                                        confirm: true,
                                                        return_url: order_url(@order),
                                                        automatic_payment_methods: { enabled: true }
                                                      })
        @order.update(status: 'paid', stripe_payment_id: payment_intent.id)
        redirect_to @order, notice: 'Order was successfully created and paid.'
      rescue Stripe::CardError => e
        @order.destroy
        flash[:alert] = e.message
        render :new
      end
    else
      flash[:alert] = 'Order could not be created. Please try again.'
      render :new
    end
  end

  def show
    @order = Order.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = 'Order not found.'
    redirect_to root_path
  end

  private

  def set_stripe_api_key
    Rails.logger.debug "Stripe API Key: #{ENV['STRIPE_SECRET_KEY']}"
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
  end

  def order_params
    params.require(:order).permit(:receiver_name, :address, :city, :postal_code, :province_id, :shipping_type_id)
  end

  def calculate_taxes
    province = current_user.province
    @gst = @shopping_cart_total * province.gst_rate
    @pst = @shopping_cart_total * province.pst_rate
    @hst = @shopping_cart_total * province.hst_rate
    @qst = @shopping_cart_total * province.qst_rate
  end
end
