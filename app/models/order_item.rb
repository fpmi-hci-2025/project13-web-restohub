# frozen_string_literal: true

class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :dish

  validates :quantity,   numericality: { greater_than: 0 }
  validates :item_price, numericality: { greater_than_or_equal_to: 0 }

  before_validation :set_item_price, on: :create

  def subtotal
    item_price * quantity
  end

  private

  def set_item_price
    self.item_price ||= dish&.price
  end
end
