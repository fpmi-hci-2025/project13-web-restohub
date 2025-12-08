# frozen_string_literal: true

module Restaurants
  class SearchQuery
    ALLOWED_SORT_BY    = %w[name rating].freeze
    ALLOWED_SORT_ORDER = %w[asc desc].freeze

    def initialize(query:, category:, sort_by: 'name', sort_order: 'asc', page: 1, per_page: 10)
      @query      = query
      @category   = category.presence
      @sort_by    = ALLOWED_SORT_BY.include?(sort_by)       ? sort_by       : 'name'
      @sort_order = ALLOWED_SORT_ORDER.include?(sort_order) ? sort_order    : 'asc'
      @page       = page.to_i.positive?                     ? page.to_i     : 1
      @per_page   = per_page.to_i.positive?                 ? per_page.to_i : 10
    end

    def call
      restaurants = enhance_with_categories(search_restaurants)
      paginate_results(restaurants)
    end

    private

    attr_reader :query, :category, :sort_by, :sort_order, :page, :per_page

    def search_restaurants
      return base_scope.order(sort_by => sort_order) if query.blank? && category.blank?

      query_hash = build_query(query:, category:, sort_by:, sort_order:)
      Restaurant.__elasticsearch__.search(query_hash)
    end

    def base_scope
      scope = Restaurant.active_partners
      if category.present?
        scope = scope.where("? = ANY(categories)", category)
      end
      scope
    end

    def enhance_with_categories(results)
      if results.is_a?(ActiveRecord::Relation)
        results
      else
        ids = results.records.map(&:id)
        Restaurant.where(id: ids).includes(:dishes).order(sort_by => sort_order)
      end
    end

    def build_query(query:, category:, sort_by:, sort_order:)
      must   = []
      filter = [{ term: { partnership_status: 'active' } }]

      if query.present?
        must << {
          query_string: {
            fields: %w[name^3 cuisine_type address dish_names],
            query: "*#{query}*",
            default_operator: 'AND'
          }
        }
      else
        must << { match_all: {} }
      end

      filter << { term: { dish_categories: category } } if category.present?

      {
        query: {
          bool: {
            must: must,
            filter: filter
          }
        },
        sort: [{ "#{sort_by}.keyword" => { order: sort_order } }],
        from: calculate_offset,
        size: per_page.to_i
      }
    end

    def calculate_offset
      (page.to_i - 1) * per_page.to_i
    end

    def paginate_results(results)
      if results.is_a?(ActiveRecord::Relation)
        results.page(page).per(per_page)
      else
        Kaminari.paginate_array(
          results.records.to_a,
          total_count: results.results.total
        )
      end
    end
  end
end
