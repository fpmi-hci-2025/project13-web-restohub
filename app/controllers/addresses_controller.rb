# frozen_string_literal: true

class AddressesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_address, only: %i[edit update destroy]

  def index
    @addresses = current_user.addresses.ordered
    @address   = current_user.addresses.build
  end

  def create
    @address = current_user.addresses.build(address_params)

    if @address.save
      redirect_to addresses_path(locale: I18n.locale),
                  notice: t('addresses.flash.created')
    else
      @addresses = current_user.addresses.ordered
      render :index, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @address.update(address_params)
      redirect_to addresses_path(locale: I18n.locale),
                  notice: t('addresses.flash.updated')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @address.destroy
    redirect_to addresses_path(locale: I18n.locale),
                notice: t('addresses.flash.deleted')
  end

  def destroy_all
    current_user.addresses.destroy_all
    redirect_to addresses_path(locale: I18n.locale),
                notice: t('addresses.flash.deleted_all')
  end

  private

  def set_address
    @address = current_user.addresses.find(params[:id])
  end

  def address_params
    params.require(:address).permit(
      :country,
      :city,
      :street,
      :house,
      :building,
      :entrance,
      :apartment,
      :is_default
    )
  end
end
