# frozen_string_literal: true

module RestaurantsHelper
  def restaurant_photo_path(restaurant)
    if restaurant.photo.attached?
      restaurant.photo.variant(resize_to_fill: [900, 260])
    else
      'restaurant_placeholder.jpg'
    end
  end

  def restaurant_categories_labels(restaurant)
    restaurant.ui_categories.map { |cat|
      key = cat.to_s.downcase
      t("restaurants.categories.#{key}", default: cat)
    }.join(' • ')
  end

  def restaurant_rating_with_star(restaurant)
    content_tag(:span, class: 'restaurant-rating d-inline-flex align-items-center') do
      concat content_tag(:i, '', class: 'fa-solid fa-star me-1 text-warning')
      concat number_with_precision(restaurant.average_rating || 0.0, precision: 1)
    end
  end
end
