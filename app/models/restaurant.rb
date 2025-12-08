# frozen_string_literal: true

class Restaurant < ApplicationRecord
  include SearchableForRestaurants

  has_one_attached :photo
  has_many :dishes, dependent: :destroy

  enum partnership_status: { active: 0, paused: 1, terminated: 2 }

  scope :active_partners, -> { active }

  after_initialize :set_default_partnership_status, if: :new_record?

  validates :name, presence: true
  validates :rating,
            numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 5.0 }
  validates :delivery_price,
            numericality: { greater_than_or_equal_to: 0.0 },
            presence: true
  validates :delivery_time_min, :delivery_time_max,
            numericality: { allow_nil: true, only_integer: true, greater_than: 0 },
            allow_nil: true

  def average_rating
    rating&.round(1)
  end

  def ui_categories
    categories = dishes.available.distinct.pluck(:category).compact
    categories = [cuisine_type].compact if categories.blank?
    categories
  end

  def delivery_time_label
    return if delivery_time_min.blank? && delivery_time_max.blank?

    if delivery_time_min.present? && delivery_time_max.present?
      "#{delivery_time_min}-#{delivery_time_max} #{I18n.t('restaurants.delivery.minutes')}"
    else
      "#{delivery_time_min || delivery_time_max}+ #{I18n.t('restaurants.delivery.minutes')}"
    end
  end

  def delivery_price_label
    if free_delivery? || delivery_price.to_f.zero?
      I18n.t('restaurants.delivery.free')
    else
      I18n.t('restaurants.delivery.paid', price: delivery_price)
    end
  end

  private

  def set_default_partnership_status
    self.partnership_status ||= :active
  end
end