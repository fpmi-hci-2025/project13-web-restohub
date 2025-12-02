# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomeHelper, type: :helper do
  it 'includes HomeHelper in helper object' do
    expect(helper.singleton_class.included_modules).to include(described_class)
  end
end
