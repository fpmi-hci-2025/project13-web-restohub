# frozen_string_literal: true

class CreateRestaurants < ActiveRecord::Migration[7.2]
  def change
    create_table :restaurants do |t|
      t.string  :name, null: false

      t.string  :categories, array: true, default: [], null: false

      t.string  :cuisine_type

      t.string  :address
      t.decimal :rating, precision: 3, scale: 2, null: false, default: 0.0

      t.integer :partnership_status, null: false, default: 0

      t.integer :delivery_time_min
      t.integer :delivery_time_max
      t.boolean :free_delivery, null: false, default: true
      t.decimal :delivery_price, precision: 8, scale: 2, null: false, default: 0.0

      t.timestamps
    end
  end
end
