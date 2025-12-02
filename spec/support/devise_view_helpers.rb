# frozen_string_literal: true

module DeviseViewHelpers
  def devise_mapping_for(model)
    @request.env['devise.mapping'] = Devise.mappings[model]
  end
end

RSpec.configure do |config|
  config.include DeviseViewHelpers, type: :view
end
