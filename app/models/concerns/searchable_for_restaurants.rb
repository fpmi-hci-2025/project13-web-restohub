# frozen_string_literal: true

module SearchableForRestaurants
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    settings index: {} do
      mappings dynamic: false do
        indexes(:name, type: :text, analyzer: 'standard') do
          indexes :keyword, type: :keyword
        end

        indexes :cuisine_type,       type: :keyword
        indexes :address,            type: :text,  analyzer: 'standard'
        indexes :rating,             type: :float
        indexes :partnership_status, type: :keyword

        indexes :dish_categories,    type: :keyword

        indexes :dish_names,         type: :text,  analyzer: 'standard'
      end
    end

    after_commit(on: %i[create])  { __elasticsearch__.index_document }
    after_commit(on: %i[update])  { __elasticsearch__.update_document }
    after_commit(on: %i[destroy]) { __elasticsearch__.delete_document }
  end

  def as_indexed_json(_options = {})
    {
      name:,
      cuisine_type:,
      address:,
      rating:,
      partnership_status:,
      dish_categories:,
      dish_names:
    }
  end

  def dish_categories
    ui_categories
  end

  def dish_names
    dishes.available.pluck(:name)
  end
end
