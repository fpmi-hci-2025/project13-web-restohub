# frozen_string_literal: true

class PaymentMethod < ApplicationRecord
  belongs_to :user

  validates :cardholder_name, :card_number, :exp_month, :exp_year, presence: true
  validates :card_number, length: { minimum: 12, maximum: 19 }
  validates :exp_month, inclusion: { in: 1..12 }
  validates :exp_year,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: Time.current.year
            }

  scope :ordered, -> { order(is_default: :desc, created_at: :desc) }
  scope :default, -> { where(is_default: true) }

  before_save :ensure_single_default, if: :is_default?
  before_save :set_last4

  def masked_number
    "•••• #{last4}"
  end

  private

  def ensure_single_default
    user.payment_methods.where.not(id: id).update_all(is_default: false)
  end

  def set_last4
    plain = card_number.to_s.gsub(/\s+/, '')
    self.last4 = plain.last(4)
  end
end
