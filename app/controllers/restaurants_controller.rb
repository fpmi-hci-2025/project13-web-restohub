# frozen_string_literal: true

class RestaurantsController < ApplicationController
  CATEGORIES = %w[Pizza Sushi Burgers Salads].freeze

  def index
    @dish_categories = CATEGORIES

    @restaurants = Restaurants::SearchQuery.new(
      query: params[:query],
      category: params[:category],
      sort_by: params[:sort_by],
      sort_order: params[:sort_order],
      page: params[:page],
      per_page: 10
    ).call
  end

  def show
    @restaurant = Restaurant.find(params[:id])

    @dish_categories =
      @restaurant.dishes.available
                 .where.not(category: [nil, ''])
                 .distinct
                 .order(:category)
                 .pluck(:category)

    @current_dish_category = params[:dish_category].presence

    @dishes =
      @restaurant.dishes.available.order(:name).then do |scope|
        if @current_dish_category.present?
          scope.where(category: @current_dish_category)
        else
          scope
        end
      end
  end
end
