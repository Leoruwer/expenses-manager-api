# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  let(:name) { 'User Name' }
  let(:email) { 'user@mail.com' }
  let(:password) { 'securePassword123' }

  let(:params) do
    {
      name: name,
      email: email,
      password: password
    }
  end

  context 'with valid params' do
    it 'is valid' do
      user = described_class.new(params)

      expect(user).to be_valid
    end

    it 'generates slug' do
      user = described_class.create(params)

      expect(user.slug).to match('user-name')
    end
  end

  describe '#model validations' do
    context 'when name is not present' do
      let(:name) { nil }

      it 'is not valid' do
        user = described_class.new(params)

        expect(user).not_to be_valid
      end
    end

    context 'when email is not present' do
      let(:email) { nil }

      it 'is not valid' do
        user = described_class.new(params)

        expect(user).not_to be_valid
      end
    end

    context 'when password is not present' do
      let(:password) { nil }

      it 'is not valid' do
        user = described_class.new(params)

        expect(user).not_to be_valid
      end
    end

    context 'when email is not unique' do
      let!(:another_user) { create(:user, email: 'user@mail.com') }

      it 'is not valid' do
        user = described_class.new(params)

        expect(user).not_to be_valid
      end
    end
  end
end
