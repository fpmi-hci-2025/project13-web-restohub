# frozen_string_literal: true

Rails.application.routes.draw do
  get "home/index"
  # корень приложения
  root 'home#index'

  # Devise
  devise_for :users
  devise_scope :user do
    get '/users/sign_out', to: 'devise/sessions#destroy'
  end

  # ActiveAdmin
  ActiveAdmin.routes(self)

  # Пример пользовательского профиля
  get '/profile', to: 'users#profile', as: :user_profile

  # Healthcheck
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Всё остальное заворачиваем в (:locale)
  scope '(:locale)', locale: /#{I18n.available_locales.join('|')}/ do
    resources :articles
    # здесь же потом добавишь остальные ресурсы (меню, блюда, заказы и т.п.)
  end
end