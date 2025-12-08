# frozen_string_literal: true

ActiveAdmin.setup do |config|
  config.site_title = 'Restohub'

  config.authentication_method = :authenticate_admin_user!
  config.current_user_method   = :current_user

  config.logout_link_path   = :destroy_user_session_path
  config.logout_link_method = :delete

  config.comments      = false
  config.comments_menu = false

  config.filter_attributes = %i[encrypted_password password password_confirmation]

  config.localize_format = :long

  meta_tags_options = { viewport: 'width=device-width, initial-scale=1' }
  config.meta_tags = meta_tags_options
  config.meta_tags_for_logged_out_pages = meta_tags_options

  config.namespace :admin do |admin|
    admin.build_menu :utility_navigation do |menu|
      menu.add(
        id: :back_to_app,
        label: proc { "<i class='fa-solid fa-backward-step'></i> #{I18n.t('active_admin.menu.back_to_app')}".html_safe },
        url: :root_path,
        html_options: { target: :blank }
      )

      admin.add_current_user_to_menu(menu)

      menu.add(
        id: :logout,
        label: proc { "<i class='fa-solid fa-arrow-right-from-bracket'></i> #{I18n.t('active_admin.menu.logout')}".html_safe },
        url: :destroy_user_session_path,
        html_options: {
          method: :delete,
          data: { confirm: I18n.t('active_admin.logout_confirmation', default: 'Are you sure?') }
        }
      )
    end
  end
end
