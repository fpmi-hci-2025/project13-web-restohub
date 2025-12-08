# frozen_string_literal: true

namespace :elasticsearch do
  desc 'Reindex Restaurant index'
  task reindex_restaurants: :environment do
    index_name = Restaurant.index_name

    puts "Deleting index #{index_name} (if exists)..."
    begin
      Restaurant.__elasticsearch__.client.indices.delete(index: index_name)
    rescue StandardError
      puts "Index #{index_name} not found, skip delete"
    end

    puts "Creating index #{index_name}..."
    Restaurant.__elasticsearch__.create_index!

    puts 'Importing Restaurant data...'
    Restaurant.import(force: true)

    puts 'Restaurant reindexation complete.'
  end
end
