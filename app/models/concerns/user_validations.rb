# frozen_string_literal: true

module UserValidations
  extend ActiveSupport::Concern

  NAME_REGEX          = /\A[[:alpha:]\s'-]+\z/
  NICKNAME_REGEX      = /\A[a-zA-Z0-9_]+\z/
  RESERVED_NICKNAMES  = %w[admin administrator root system support manager courier].freeze
  PHONE_REGEX         = /\A\+?[0-9\s\-()]+\z/
  PASSWORD_REGEX      = /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}\z/

  private_constant :NAME_REGEX, :NICKNAME_REGEX, :RESERVED_NICKNAMES,
                   :PHONE_REGEX, :PASSWORD_REGEX

  # rubocop:disable Metrics/BlockLength
  included do
    validates :first_name,
              presence: true,
              length: { maximum: 50 },
              format: {
                with: NAME_REGEX,
                message: I18n.t('errors.messages.invalid_name')
              }

    validates :last_name,
              presence: true,
              length: { maximum: 50 },
              format: {
                with: NAME_REGEX,
                message: I18n.t('errors.messages.invalid_name')
              }

    validates :email,
              presence: true,
              uniqueness: { case_sensitive: false },
              format: {
                with: URI::MailTo::EMAIL_REGEXP,
                allow_blank: true,
                message: I18n.t('errors.messages.invalid_email',
                                default: 'is not a valid email')
              }

    validates :nickname,
              presence: true,
              uniqueness: { case_sensitive: false },
              length: { minimum: 3, maximum: 30 },
              format: {
                with: NICKNAME_REGEX,
                message: I18n.t('errors.messages.invalid_nickname_format')
              }

    validate :nickname_not_used_as_email
    validate :nickname_not_reserved

    validates :phone,
              presence: true,
              length: { minimum: 7, maximum: 20 },
              format: {
                with: PHONE_REGEX,
                message: I18n.t('errors.messages.invalid_phone_format')
              }

    validates :status, presence: true

    validate :password_complexity, if: -> { password.present? }
  end
  # rubocop:enable Metrics/BlockLength

  private

  def nickname_not_used_as_email
    return if nickname.blank?
    return unless self.class.where('LOWER(email) = ?', nickname.downcase)
                      .where.not(id: id)
                      .exists?

    errors.add(:nickname, :taken)
  end

  def nickname_not_reserved
    return if nickname.blank?
    return unless RESERVED_NICKNAMES.any? { |reserved| nickname.downcase.include?(reserved) }

    errors.add(:nickname, I18n.t('errors.messages.nickname_reserved'))
  end

  def password_complexity
    return if password =~ PASSWORD_REGEX

    errors.add(
      :password,
      I18n.t('errors.messages.weak_password')
    )
  end
end
