# frozen_string_literal: true

class CreateDeliveries < ActiveRecord::Migration[7.2]
  def change
    create_table :deliveries do |t|
      t.references :order, null: false, foreign_key: true, index: { unique: true }
      t.references :courier, null: false, foreign_key: { to_table: :users }

      t.integer  :status, null: false, default: 0
      t.datetime :eta_planned
      t.datetime :eta_actual

      t.timestamps
    end
  end
end
