# frozen_string_literal: true

class CreateDishes < ActiveRecord::Migration[7.2]
  def change
    create_table :dishes do |t|
      t.references :restaurant, null: false, foreign_key: true
      t.string  :name, null: false
      t.string  :category
      t.decimal :price, precision: 8, scale: 2, null: false
      t.boolean :is_available, null: false, default: true

      t.timestamps
    end
  end
end
