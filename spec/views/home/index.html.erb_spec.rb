# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'home/index.html.erb', type: :view do
  before do
    render
  end

  it 'renders home title' do
    expect(rendered).to include(I18n.t('pages.home.title', default: 'Welcome to RestoHub'))
  end
end
