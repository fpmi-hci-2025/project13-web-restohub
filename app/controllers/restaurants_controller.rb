# frozen_string_literal: true

class RestaurantsController < ApplicationController
  CATEGORIES = Restaurant::CATEGORIES

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
  end
end
