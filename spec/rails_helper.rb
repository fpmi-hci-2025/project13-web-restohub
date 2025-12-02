# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories.
Rails.root.glob('spec/support/**/*.rb').each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

# See https://github.com/thoughtbot/shoulda-matchers#rails-apps
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

RSpec.configure do |config|
  # devize-хелперы для контроллеров
  config.include Devise::Test::ControllerHelpers, type: :controller
  # при желании можно добросить:
  # config.include Devise::Test::IntegrationHelpers, type: :request

  config.include Devise::Test::IntegrationHelpers, type: :request

  # FactoryBot
  config.include FactoryBot::Syntax::Methods

  # Мы используем DatabaseCleaner, поэтому транзакции выключаем
  config.use_transactional_fixtures = false

  # Автоматическое определение типа спеки по пути к файлу
  config.infer_spec_type_from_file_location!

  # Фильтрация трейсбеков
  config.filter_rails_from_backtrace!

  # Всегда гоняем тесты с дефолтной локалью приложения,
  # чтобы не было сюрпризов с I18n.
  config.around do |example|
    I18n.with_locale(I18n.default_locale) { example.run }
  end

  config.before(:suite) do
    Rails.application.routes.default_url_options[:locale] = I18n.default_locale
  end
end
