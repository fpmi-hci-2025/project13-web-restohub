# frozen_string_literal: true

module UserValidations
  extend ActiveSupport::Concern

  included do
    validates :first_name,
              presence: true,
              length: { maximum: 50 },
              format: {
                with: NAME_REGEX,
                message: 'can contain only letters, spaces, apostrophes and dashes'
              }

    validates :last_name,
              presence: true,
              length: { maximum: 50 },
              format: {
                with: NAME_REGEX,
                message: 'can contain only letters, spaces, apostrophes and dashes'
              }

    validates :email,
              presence: true,
              uniqueness: { case_sensitive: false },
              format: {
                with: URI::MailTo::EMAIL_REGEXP,
                allow_blank: true, # при пустом будет только "can't be blank"
                message: I18n.t('errors.messages.invalid_email', default: 'is not a valid email')
              }

    validates :nickname,
              presence: true,
              uniqueness: { case_sensitive: false },
              length: { minimum: 3, maximum: 30 },
              format: {
                with: NICKNAME_REGEX,
                message: 'can contain only letters, numbers and underscores'
              }

    validate :nickname_not_used_as_email
    validate :nickname_not_reserved

    validates :phone,
              presence: true,
              length: { minimum: 7, maximum: 20 },
              format: {
                with: PHONE_REGEX,
                message: 'can contain only digits, spaces, +, - and brackets'
              }

    validates :status, presence: true

    validate :password_complexity, if: -> { password.present? }

    private

    NAME_REGEX      = /\A[[:alpha:]\s'-]+\z/.freeze
    NICKNAME_REGEX  = /\A[a-zA-Z0-9_]+\z/.freeze
    RESERVED_NICKNAMES = %w[admin administrator root system support manager courier].freeze
    PHONE_REGEX     = /\A\+?[0-9\s\-\(\)]+\z/.freeze
    PASSWORD_REGEX  = /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}\z/.freeze

    def nickname_not_used_as_email
      return if nickname.blank?

      return unless self.class.where('LOWER(email) = ?', nickname.downcase).where.not(id: id).exists?

      errors.add(:nickname, :taken)
    end

    def nickname_not_reserved
      return if nickname.blank?

      return unless RESERVED_NICKNAMES.any? { |reserved| nickname.downcase.include?(reserved) }

      errors.add(:nickname, 'is reserved and cannot be used')
    end

    def password_complexity
      return if password =~ PASSWORD_REGEX

      errors.add(
        :password,
        'must be at least 8 characters and include one uppercase letter, one lowercase letter and one digit'
      )
    end
  end
end
