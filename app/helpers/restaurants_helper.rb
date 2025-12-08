# frozen_string_literal: true

module RestaurantsHelper
  def restaurant_photo_path(restaurant)
    if restaurant.photo.attached?
      restaurant.photo.variant(:card)
    else
      'restaurant_placeholder.jpg'
    end
  end

  def dish_photo_path(dish)
    if dish.photo.attached?
      dish.photo.variant(:card)
    else
      'dish_placeholder.jpg'
    end
  end

  def restaurant_categories_labels(restaurant)
    restaurant.ui_categories.map { |cat|
      key = cat.to_s.downcase
      t("restaurants.categories.#{key}", default: cat)
    }.join(' • ')
  end

  def restaurant_rating_with_star(restaurant)
    avg = restaurant.average_rating || 0.0

    content_tag(:span, class: 'restaurant-rating d-inline-flex align-items-center') do
      concat content_tag(:i, '', class: 'bi bi-star-fill restaurant-rating-star me-1')
      concat avg.round(1).to_s
    end
  end
end
