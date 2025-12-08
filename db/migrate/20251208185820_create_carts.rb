# frozen_string_literal: true

class CreateCarts < ActiveRecord::Migration[7.2]
  def change
    create_table :carts do |t|
      t.references :user, null: false, foreign_key: true
      t.string  :status,   null: false, default: 'active'
      t.decimal :subtotal, null: false, default: 0.0, precision: 10, scale: 2

      t.timestamps
    end
  end
end
