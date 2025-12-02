# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }

  context 'with valid factory' do
    it 'is valid' do
      expect(user).to be_valid
    end
  end

  describe 'devise modules' do
    it 'includes database_authenticatable' do
      expect(described_class.devise_modules).to include(:database_authenticatable)
    end

    it 'uses login authentication key' do
      expect(described_class.authentication_keys).to eq([:login])
    end
  end

  describe 'enums' do
    it 'defines status enum' do
      expect(user).to define_enum_for(:status).with_values(active: 0, blocked: 1)
    end
  end

  describe 'validations' do
    it 'validates presence of first_name' do
      expect(user).to validate_presence_of(:first_name)
    end

    it 'validates presence of last_name' do
      expect(user).to validate_presence_of(:last_name)
    end

    it 'validates presence of email' do
      expect(user).to validate_presence_of(:email)
    end

    it 'validates uniqueness of email (case insensitive)' do
      expect(user).to validate_uniqueness_of(:email).case_insensitive
    end

    it 'validates presence of nickname' do
      expect(user).to validate_presence_of(:nickname)
    end

    it 'validates uniqueness of nickname (case insensitive)' do
      expect(user).to validate_uniqueness_of(:nickname).case_insensitive
    end

    it 'validates presence of phone' do
      expect(user).to validate_presence_of(:phone)
    end

    it 'validates presence of status' do
      expect(user).to validate_presence_of(:status)
    end
  end

  describe '#full_name' do
    before do
      user.first_name = 'Anna'
      user.last_name  = 'Pavlova'
    end

    it 'returns first_name + last_name' do
      expect(user.full_name).to eq('Anna Pavlova')
    end
  end

  describe '#active_for_authentication?' do
    context 'when status is active' do
      before { user.status = :active }

      it 'returns true' do
        expect(user.active_for_authentication?).to be true
      end
    end

    context 'when status is blocked' do
      before { user.status = :blocked }

      it 'returns false' do
        expect(user.active_for_authentication?).to be false
      end
    end
  end

  describe '#inactive_message' do
    before { user.status = :blocked }

    it 'returns :blocked for blocked user' do
      expect(user.inactive_message).to eq(:blocked)
    end
  end

  describe '#login (UserLogin concern)' do
    context 'when @login is explicitly set' do
      before { user.login = 'custom_login' }

      it 'returns @login' do
        expect(user.login).to eq('custom_login')
      end
    end

    context 'when @login is not set, but nickname is present' do
      before do
        user.nickname = 'nick_name'
        user.instance_variable_set(:@login, nil)
      end

      it 'returns nickname' do
        expect(user.login).to eq('nick_name')
      end
    end

    context 'when neither @login nor nickname is set' do
      before do
        user.nickname = nil
        user.instance_variable_set(:@login, nil)
      end

      it 'falls back to email' do
        expect(user.login).to eq(user.email)
      end
    end
  end

  describe '.find_for_database_authentication' do
    let!(:user_record) do
      create(
        :user,
        email: 'test@example.com',
        nickname: 'restouser'
      )
    end

    context 'when login matches email case-insensitively' do
      let(:found) { described_class.find_for_database_authentication(login: 'TEST@example.com') }

      it 'returns the user' do
        expect(found).to eq(user_record)
      end
    end

    context 'when login matches nickname case-insensitively' do
      let(:found) { described_class.find_for_database_authentication(login: 'RESTOUSER') }

      it 'returns the user' do
        expect(found).to eq(user_record)
      end
    end

    context 'when no user matches login' do
      let(:found) { described_class.find_for_database_authentication(login: 'unknown') }

      it 'returns nil' do
        expect(found).to be_nil
      end
    end
  end

  describe 'password complexity' do
    context 'when password is too simple' do
      before do
        user.password = 'password'
        user.password_confirmation = 'password'
        user.valid?
      end

      it 'adds error on password' do
        expect(user.errors[:password]).to be_present
      end
    end

    context 'when password meets complexity rules' do
      before do
        user.password = 'Password1'
        user.password_confirmation = 'Password1'
      end

      it 'is valid' do
        expect(user).to be_valid
      end
    end
  end

  describe 'nickname validations' do
    context 'when nickname is used as another user email' do
      before do
        create(:user, email: 'used_as_email@example.com')
        user.nickname = 'used_as_email@example.com'
        user.valid?
      end

      it 'adds taken error on nickname' do
        expect(user.errors[:nickname]).to include(I18n.t('errors.messages.taken'))
      end
    end

    context 'when nickname includes reserved word' do
      before do
        user.nickname = 'best_admin_ever'
        user.valid?
      end

      it 'adds error on nickname' do
        expect(user.errors[:nickname]).to be_present
      end
    end
  end
end
