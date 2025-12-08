# frozen_string_literal: true

class Restaurant < ApplicationRecord
  include SearchableForRestaurants

  CATEGORIES = %w[Pizza Sushi Burgers Salads].freeze

  has_one_attached :photo do |attachable|
    attachable.variant :card,  resize_to_fill: [1500, 260]
    attachable.variant :thumb, resize_to_fill: [60, 60]
  end

  has_many :dishes, dependent: :destroy

  enum partnership_status: { active: 0, paused: 1, terminated: 2 }

  scope :active_partners, -> { active }

  after_initialize :set_default_partnership_status, if: :new_record?
  before_save :normalize_categories, :sync_cuisine_type_from_categories

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
    cats = categories.presence || []
    cats = [cuisine_type].compact if cats.blank?
    cats
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
      formatted_price =
        ApplicationController.helpers.number_with_precision(
          delivery_price,
          precision: 2,
          strip_insignificant_zeros: true
        )

      I18n.t('restaurants.delivery.paid', price: formatted_price)
    end
  end

  private

  def set_default_partnership_status
    self.partnership_status ||= :active
  end

  def normalize_categories
    self.categories = Array(categories).reject(&:blank?).map(&:to_s)
  end

  def sync_cuisine_type_from_categories
    self.cuisine_type = ui_categories.join(', ')
  end
end
