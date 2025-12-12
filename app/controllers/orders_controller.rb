# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: %i[show]

  def index
    @orders = current_user
                .orders
                .where.not(status: :delivered) # доставленные не показываем
                .includes(:restaurant)
                .recent
  end

  def show; end

  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    @cart       = current_user.cart

    items_scope = @cart.cart_items.includes(:dish)
                       .where(dishes: { restaurant_id: @restaurant.id })
    @items      = items_scope.to_a

    if @items.blank?
      redirect_to cart_path(locale: I18n.locale, restaurant_id: @restaurant.id),
                  alert: t('orders.checkout.cart_empty')
      return
    end

    @addresses       = current_user.addresses.ordered
    @default_address = @addresses.default.first || @addresses.first

    @payment_methods = current_user.payment_methods
    @default_payment = @payment_methods.default.first || @payment_methods.first

    @order = Order.new(
      user:       current_user,
      restaurant: @restaurant,
      address:    @default_address,
      order_type: :delivery
    )
  end

  def create
    @restaurant = Restaurant.find(order_params[:restaurant_id])
    @cart       = current_user.cart

    items_scope = @cart.cart_items.includes(:dish)
                       .where(dishes: { restaurant_id: @restaurant.id })
    @items      = items_scope.to_a

    if @items.blank?
      redirect_to cart_path(locale: I18n.locale, restaurant_id: @restaurant.id),
                  alert: t('orders.checkout.cart_empty')
      return
    end

    payment_method_type = order_params[:payment_method]

    Order.transaction do
      @order = current_user.orders.build(
        restaurant:      @restaurant,
        address_id:      order_params[:address_id],
        order_type:      order_params[:order_type] || :delivery,
        comment:         order_params[:comment],
        status:          :pending,
        payment_status:  (payment_method_type == 'card' ? :paid : :unpaid)
      )

      @items.each do |item|
        @order.order_items.build(
          dish:       item.dish,
          quantity:   item.quantity,
          item_price: item.dish.price
        )
      end

      @order.calculate_total_amount

      if @order.save
        if payment_method_type == 'card'
          @order.payments.create!(
            provider:    'internal',
            method_type: 'card',
            amount:      @order.total_amount,
            status:      :succeeded,
            paid_at:     Time.current
          )
        end

        items_scope.destroy_all

        redirect_to order_path(@order, locale: I18n.locale),
                    notice: t('orders.flash.created')
      else
        @addresses       = current_user.addresses.ordered
        @payment_methods = current_user.payment_methods
        render :new, status: :unprocessable_entity
      end
    end
  end

  private

  def set_order
    @order = current_user.orders.find(params[:id])
  end

  def order_params
    params.require(:order).permit(
      :restaurant_id,
      :address_id,
      :order_type,
      :payment_method,
      :comment
    )
  end
end
