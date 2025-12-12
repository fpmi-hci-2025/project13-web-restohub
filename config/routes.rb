# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index'

  scope '(:locale)', locale: /#{I18n.available_locales.join('|')}/ do
    devise_for :users,
               controllers: {
                 registrations: 'users/registrations',
                 sessions: 'users/sessions'
               }

    resources :restaurants, only: %i[index show]

    resource :cart, only: :show do
      post   :add_item
      patch  :update_item
      delete :clear_for_restaurant
    end

    resource :profile, only: %i[show edit update]
    resources :orders, only: %i[index show new create]

    resources :addresses, only: %i[index create edit update destroy] do
      delete :destroy_all, on: :collection
    end

    resources :payment_methods, only: %i[index create edit update destroy] do
      delete :destroy_all, on: :collection
    end
  end

  ActiveAdmin.routes(self)

  get 'up' => 'rails/health#show', as: :rails_health_check
end
