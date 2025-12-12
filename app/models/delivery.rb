# frozen_string_literal: true

class Delivery < ApplicationRecord
  belongs_to :order
  belongs_to :courier, class_name: "User"

  enum :status, { pending: 0, accepted: 1, preparing: 2, on_the_way: 3, delivered: 4, cancelled: 5 }

  validates :status, presence: true
end
