# frozen_string_literal: true

class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy
  has_many :dishes, through: :cart_items

  STATUSES = %w[active abandoned].freeze

  validates :status, inclusion: { in: STATUSES }

  def restaurants
    Restaurant.joins(dishes: :cart_items).where(cart_items: { cart_id: id }).distinct
  end

  def subtotal_for_restaurant(restaurant)
    cart_items.joins(:dish).where(dishes: { restaurant_id: restaurant.id })
              .sum('cart_items.quantity * dishes.price')
  end

  def recalc_subtotal!
    value = cart_items.joins(:dish).sum('cart_items.quantity * dishes.price')
    update!(subtotal: value)
  end
end
