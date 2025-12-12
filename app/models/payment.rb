# frozen_string_literal: true

class Payment < ApplicationRecord
  belongs_to :order

  enum :status, { pending: 0, succeeded: 1, failed: 2, refunded: 3 }

  validates :amount, numericality: { greater_than: 0 }
end
