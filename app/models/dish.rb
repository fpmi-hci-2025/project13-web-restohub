# frozen_string_literal: true

class Dish < ApplicationRecord
  belongs_to :restaurant

  scope :available, -> { where(is_available: true) }

  validates :name,  presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
end
