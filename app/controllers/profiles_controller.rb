# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @addresses_count = @user.addresses.count
    @default_payment = @user.payment_methods.default.first
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update(profile_params)
      redirect_to profile_path(locale: I18n.locale),
                  notice: t('profile.flash.updated')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:user).permit(
      :login,
      :first_name,
      :last_name,
      :avatar
    )
  end
end
