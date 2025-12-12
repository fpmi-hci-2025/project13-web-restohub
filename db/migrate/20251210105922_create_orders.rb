# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.string :order_number, null: false
      t.references :user,       null: false, foreign_key: true
      t.references :restaurant, null: false, foreign_key: true
      t.references :address, foreign_key: true

      t.integer :order_type, null: false, default: 0
      t.integer :status, null: false, default: 0
      t.decimal :total_amount, precision: 10, scale: 2, null: false, default: 0.0
      t.integer :payment_status,  null: false, default: 0
      t.decimal :risk_score,      precision: 5, scale: 2, null: false, default: 0.0
      t.text    :comment

      t.timestamps
    end

    add_index :orders, :order_number, unique: true
  end
end
