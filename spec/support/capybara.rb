# frozen_string_literal: true

Capybara.register_driver :selenium_chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

# Будем использовать headless Chrome для js-спек
Capybara.javascript_driver = :selenium_chrome_headless

# Для корректного отображения HTML-скриншотов (CSS/JS грузится с этой базы)
Capybara.asset_host = 'http://localhost:3000'

RSpec.configure do |config|
  config.before(:each, :js) do
    Capybara.page.current_window.resize_to(1024, 768)
  end
end
