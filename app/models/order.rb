# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :user
  belongs_to :restaurant
  belongs_to :address, optional: true

  has_many :order_items, dependent: :destroy
  has_one  :delivery, dependent: :destroy
  has_many :payments, dependent: :destroy

  enum :order_type, { delivery: 0, pickup: 1 }

  enum :status, { pending: 0, accepted: 1, preparing: 2, on_the_way: 3, delivered: 4, cancelled: 5 }

  enum :payment_status, { unpaid: 0, paid: 1, refunded: 2 }

  validates :order_number, presence: true, uniqueness: true
  validates :total_amount, numericality: { greater_than_or_equal_to: 0 }

  before_validation :generate_order_number, on: :create

  scope :recent, -> { order(created_at: :desc) }

  def calculate_total_amount
    self.total_amount =
      order_items.to_a.sum { |item| item.item_price * item.quantity }
  end

  private

  def generate_order_number
    return if order_number.present?

    self.order_number =
      "R#{Time.current.strftime('%y%m%d')}#{SecureRandom.random_number(1_000_000).to_s.rjust(6, '0')}"
  end
end
