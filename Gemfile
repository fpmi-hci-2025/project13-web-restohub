# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.3.4'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.2.2'
# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'
# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem 'cssbundling-rails'
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'
# [https://github.com/rails/sass-rails]
gem 'sass-rails'
# Use Redis adapter to run Action Cable in production
# gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem 'active_storage_validations', '~> 1.1', '>= 1.1.4'
gem 'image_processing', '~> 1.2'
gem 'mini_magick', '~> 5.3'

# [https://github.com/kaminari/kaminari]
gem 'kaminari', '~> 1.2.2'

# Centralization of locale data [https://github.com/svenfuchs/rails-i18n]
gem 'rails-i18n', '~> 7.0.0'

# [https://github.com/heartcombo/devise]
gem 'devise'

# [https://github.com/RolifyCommunity/rolify]
gem 'rolify'

# RoR framework for creating elegant backends for website administration. [https://github.com/activeadmin/activeadmin]
gem 'activeadmin'

# [https://github.com/cprodhomme/arctic_admin]
gem 'arctic_admin'

gem 'sassc-rails'

gem 'elasticsearch',       '~> 7.17'
gem 'elasticsearch-model', '~> 7.2'
gem 'elasticsearch-rails', '~> 7.2'

# Иконки, которые использует ArcticAdmin
gem 'font-awesome-rails'

group :development, :test do
  # [https://rubygems.org/gems/factory_bot_rails]
  gem 'factory_bot_rails', '~> 6.4', '>= 6.4.3'

  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem 'brakeman', require: false

  # rubocop [https://github.com/rubocop/rubocop]
  gem 'rubocop', require: false
  gem 'rubocop-capybara', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rails-omakase', require: false
  gem 'rubocop-rspec', require: false

  gem 'dotenv-rails'

  # [https://github.com/teamcapybara/capybara]
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'webdrivers'

  # [https://github.com/rspec/rspec-rails/tree/6-1-maintenance]
  gem 'rspec-rails', '~> 6.1.0'

  # [https://rubygems.org/gems/pry/versions/0.14.1]
  gem 'pry', '~> 0.14.1'

  # [https://rubygems.org/gems/faker/versions/3.4.2]
  gem 'faker', '~> 3.4', '>= 3.4.2'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'
end

group :test do
  # [https://rubygems.org/gems/database_cleaner/versions/2.0.2]
  gem 'database_cleaner', '~> 2.0', '>= 2.0.2'

  # [https://github.com/thoughtbot/shoulda-matchers]
  gem 'shoulda-matchers', '~> 6.0'

  # [https://rubygems.org/gems/simplecov]
  gem 'simplecov', '~> 0.22.0'

  # [https://github.com/rails/rails-controller-testing]
  gem 'rails-controller-testing'
end
