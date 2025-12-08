# frozen_string_literal: true

class CartsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart

  def show
    @restaurants = @cart.restaurants

    @current_restaurant =
      if params[:restaurant_id].present?
        @restaurants.find_by(id: params[:restaurant_id])
      else
        @restaurants.first
      end

    if @current_restaurant
      @items    = items_for_restaurant(@current_restaurant)
      @subtotal = @cart.subtotal_for_restaurant(@current_restaurant)
    else
      @items    = CartItem.none
      @subtotal = 0
    end
  end

  def add_item
    dish = Dish.find(params[:dish_id])

    cart_item = @cart.cart_items.find_or_initialize_by(dish: dish)

    add_qty = params[:quantity].presence.to_i
    add_qty = 1 if add_qty <= 0

    # ВАЖНО: если запись новая — стартуем с 0, а не с дефолтного 1
    current_qty = cart_item.persisted? ? cart_item.quantity : 0
    cart_item.quantity = current_qty + add_qty

    if cart_item.save
      @cart.recalc_subtotal!
      redirect_back fallback_location: restaurant_path(dish.restaurant, locale: I18n.locale),
                    notice: t('cart.flash.added')
    else
      redirect_back fallback_location: restaurant_path(dish.restaurant, locale: I18n.locale),
                    alert: t('cart.flash.error')
    end
  end

  def update_item
    cart_item    = @cart.cart_items.find(params[:id])
    new_quantity = params[:quantity].to_i

    if new_quantity <= 0
      cart_item.destroy
    else
      cart_item.update(quantity: new_quantity)
    end

    @cart.recalc_subtotal!

    redirect_to cart_path(locale: I18n.locale,
                          restaurant_id: params[:restaurant_id])
  end

  def clear_for_restaurant
    restaurant = Restaurant.find(params[:restaurant_id])

    items_for_restaurant(restaurant).destroy_all
    @cart.recalc_subtotal!

    redirect_to cart_path(locale: I18n.locale),
                notice: t('cart.flash.cleared')
  end

  private

  def set_cart
    @cart = current_user.cart || current_user.create_cart!
  end

  def items_for_restaurant(restaurant)
    @cart.cart_items
         .joins(:dish)
         .includes(:dish)
         .where(dishes: { restaurant_id: restaurant.id })
  end
end
