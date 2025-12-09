# frozen_string_literal: true

class CreateAddresses < ActiveRecord::Migration[7.2]
  def change
    create_table :addresses do |t|
      t.references :user, null: false, foreign_key: true

      t.string  :country,  null: false
      t.string  :city,     null: false
      t.string  :street,   null: false
      t.string  :house,    null: false
      t.string  :building
      t.string  :entrance
      t.string  :apartment

      t.boolean :is_default, null: false, default: false

      t.string :address_text

      t.timestamps
    end
  end
end
