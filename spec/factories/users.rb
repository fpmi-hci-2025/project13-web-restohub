# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { 'Anna' }
    last_name  { 'Pavlova' }
    sequence(:nickname) { |n| "restohub_user#{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    phone { '+375 29 123-45-67' }
    status { :active }

    password { 'Password1' }
    password_confirmation { 'Password1' }
  end
end
