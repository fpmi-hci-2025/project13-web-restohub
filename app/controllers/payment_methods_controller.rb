# frozen_string_literal: true

class PaymentMethodsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_payment_method, only: %i[edit update destroy]

  def index
    @payment_methods = current_user.payment_methods.ordered
    @payment_method  = current_user.payment_methods.build
  end

  def create
    @payment_method = current_user.payment_methods.build(payment_method_params)

    if @payment_method.save
      redirect_to payment_methods_path(locale: I18n.locale),
                  notice: t('payment_methods.flash.created')
    else
      @payment_methods = current_user.payment_methods.ordered
      render :index, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @payment_method.update(payment_method_params)
      redirect_to payment_methods_path(locale: I18n.locale),
                  notice: t('payment_methods.flash.updated')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @payment_method.destroy
    redirect_to payment_methods_path(locale: I18n.locale),
                notice: t('payment_methods.flash.deleted')
  end

  def destroy_all
    current_user.payment_methods.destroy_all
    redirect_to payment_methods_path(locale: I18n.locale),
                notice: t('payment_methods.flash.deleted_all')
  end

  private

  def set_payment_method
    @payment_method = current_user.payment_methods.find(params[:id])
  end

  def payment_method_params
    params.require(:payment_method).permit(
      :cardholder_name,
      :card_number,
      :exp_month,
      :exp_year,
      :is_default
    )
  end
end
