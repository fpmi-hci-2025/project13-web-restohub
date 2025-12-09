# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable,
         authentication_keys: [:login]

  rolify
  include UserLogin
  include UserValidations

  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_fill: [64, 64]
  end

  has_one  :cart, dependent: :destroy
  has_many :addresses,       dependent: :destroy
  has_many :payment_methods, dependent: :destroy

  enum :status, { active: 0, blocked: 1 }


  after_create :assign_default_role

  def admin?
    has_role?(:admin)
  end

  def courier?
    has_role?(:courier)
  end

  def customer?
    has_role?(:user)
  end

  def active_for_authentication?
    super && active?
  end

  def inactive_message
    blocked? ? :blocked : super
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def display_name
    nickname.presence || full_name.presence || email
  end

  private

  def assign_default_role
    add_role(:user) if roles.blank?
  end
end
