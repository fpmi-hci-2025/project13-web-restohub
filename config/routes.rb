# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index'

  scope '(:locale)', locale: /#{I18n.available_locales.join('|')}/ do

    devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }
  end

  ActiveAdmin.routes(self)

  get 'up' => 'rails/health#show', as: :rails_health_check
end
