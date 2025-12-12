# frozen_string_literal: true

class CreatePayments < ActiveRecord::Migration[7.2]
  def change
    create_table :payments do |t|
      t.references :order, null: false, foreign_key: true

      t.string  :provider
      t.string  :method_type
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.integer :status, null: false, default: 0
      t.datetime :paid_at

      t.timestamps
    end
  end
end
