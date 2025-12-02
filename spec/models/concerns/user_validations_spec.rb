# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserValidations, type: :model do
  it 'is included into User' do
    expect(User.included_modules).to include(described_class)
  end
end
