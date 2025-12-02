# frozen_string_literal: true

require 'simplecov'
SimpleCov.start 'rails'

require 'active_storage_validations/matchers'
require 'capybara/rspec'
require 'database_cleaner/active_record'

RSpec.configure do |config|
  config.include ActiveStorageValidations::Matchers

  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.
  config.expect_with :rspec do |expectations|
    # This option will default to `true` in RSpec 4. It makes the `description`
    # and `failure_message` of custom matchers include text for helper methods
    # defined using `chain`, e.g.:
    #     be_bigger_than(2).and_smaller_than(4).description
    #     # => "be bigger than 2 and smaller than 4"
    # ...rather than:
    #     # => "be bigger than 2"
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object.
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  # Ниже — рекомендованные настройки RSpec (можно раскомментировать по вкусу):

  # config.filter_run_when_matching :focus
  # config.example_status_persistence_file_path = "spec/examples.txt"
  # config.disable_monkey_patching!
  #
  # if config.files_to_run.one?
  #   config.default_formatter = "doc"
  # end
  #
  # config.profile_examples = 10
  # config.order = :random
  # Kernel.srand config.seed
end