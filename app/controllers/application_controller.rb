# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def authenticate_admin_user!
    authenticate_user!

    unless current_user&.admin?
      redirect_to root_path, flash: { alert: I18n.t('errors.messages.no_access') }
    end
  end
end