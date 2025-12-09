# frozen_string_literal: true

class CreatePaymentMethods < ActiveRecord::Migration[7.2]
  def change
    create_table :payment_methods do |t|
      t.references :user, null: false, foreign_key: true

      t.string  :cardholder_name, null: false
      t.string  :card_number,     null: false
      t.string  :last4,           null: false
      t.integer :exp_month,       null: false
      t.integer :exp_year,        null: false
      t.boolean :is_default,      null: false, default: false

      t.timestamps
    end
  end
end
