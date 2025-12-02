# frozen_string_literal: true

module UserLogin
  extend ActiveSupport::Concern

  included do
    attr_writer :login
  end

  def login
    @login || nickname || email
  end

  class_methods do
    def find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      if (login = conditions.delete(:login)&.downcase)
        where(conditions.to_h)
          .where('LOWER(email) = :value OR LOWER(nickname) = :value', value: login)
          .first
      else
        where(conditions.to_h).first
      end
    end
  end
end
