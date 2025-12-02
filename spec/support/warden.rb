# frozen_string_literal: true

RSpec.configure do |config|
  config.include Warden::Test::Helpers, type: :feature
  config.include Warden::Test::Helpers, type: :system

  config.before(:suite) { Warden.test_mode! }
  config.after { Warden.test_reset! }
end
