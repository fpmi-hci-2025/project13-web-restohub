# frozen_string_literal: true

class Dish < ApplicationRecord
  belongs_to :restaurant
  has_many   :order_items,  dependent: :restrict_with_exception
  has_many :cart_items, dependent: :destroy
  has_many :carts, through: :cart_items

  has_one_attached :photo do |attachable|
    attachable.variant :card, resize_to_fill: [96, 96]
  end


  scope :available, -> { where(is_available: true) }

  validates :name,  presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
end
