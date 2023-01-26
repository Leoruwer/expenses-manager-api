# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Account do
  let!(:current_user) { create(:user) }

  context 'with valid params' do
    it 'is valid' do
      account = described_class.new(name: 'Account', user: current_user)

      expect(account).to be_valid
    end

    it 'generates slug' do
      account = described_class.create(name: 'Account name', user: current_user)

      expect(account.slug).to match('account-name')
    end
  end

  describe 'model validations' do
    it 'validates name presence' do
      account = described_class.new(name: nil, user: current_user)

      expect(account).not_to be_valid
    end

    describe 'validates name uniqueness' do
      let!(:another_user) { create(:user) }

      it 'is not valid when the user has account with same name' do
        described_class.create(name: 'Account', user: current_user)
        account = described_class.new(name: 'Account', user: current_user)

        expect(account).not_to be_valid
      end

      it 'is valid when another user has account with same name' do
        described_class.create(name: 'Account', user: another_user)
        account = described_class.new(name: 'Account', user: current_user)

        expect(account).to be_valid
      end
    end
  end
end
