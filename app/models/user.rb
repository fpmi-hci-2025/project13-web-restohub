# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable,
         authentication_keys: [:login]

  rolify
  include UserLogin
  include UserValidations

  enum :status, { active: 0, blocked: 1 }

  def active_for_authentication?
    super && active?
  end

  def inactive_message
    blocked? ? :blocked : super
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
