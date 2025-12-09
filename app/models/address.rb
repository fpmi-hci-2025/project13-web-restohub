# frozen_string_literal: true

class Address < ApplicationRecord
  belongs_to :user

  validates :country, :city, :street, :house, presence: true

  scope :ordered, -> { order(is_default: :desc, created_at: :desc) }
  scope :default, -> { where(is_default: true) }

  before_save :ensure_single_default, if: :is_default?
  before_save :build_address_text

  def full_address
    [
      country,
      city,
      "#{street} #{house}".strip,
      building.presence,
      entrance.presence,
      apartment.presence
    ].compact.join(', ')
  end

  private

  def ensure_single_default
    user.addresses.where.not(id: id).update_all(is_default: false)
  end

  def build_address_text
    self.address_text = full_address
  end
end
