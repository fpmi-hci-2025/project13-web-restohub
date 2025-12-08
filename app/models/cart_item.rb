# frozen_string_literal: true

class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :dish

  delegate :restaurant, to: :dish

  validates :quantity,
            numericality: { only_integer: true, greater_than: 0 }

  def line_total
    dish.price * quantity
  end
end
