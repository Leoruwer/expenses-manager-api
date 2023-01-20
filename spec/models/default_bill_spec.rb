# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe DefaultBill do
  let!(:current_user) { create(:user) }

  context 'with valid params' do
    it 'is valid' do
      default_bill = described_class.new(name: 'Default Bill', user: current_user)

      expect(default_bill).to be_valid
    end

    it 'generates slug' do
      default_bill = described_class.create(name: 'Default Bill', user: current_user)

      expect(default_bill.slug).to match('default-bill')
    end
  end

  describe 'model validations' do
    it 'validates name presence' do
      default_bill = described_class.new(name: nil, user: current_user)

      expect(default_bill).not_to be_valid
    end

    context 'validates name uniqueness' do
      let!(:another_user) { create(:user) }

      it 'is not valid when the user has default bill with same name' do
        described_class.create(name: 'Default Bill', user: current_user)
        default_bill = described_class.new(name: 'Default Bill', user: current_user)

        expect(default_bill).not_to be_valid
      end

      it 'is valid when another user has default bill with same name' do
        described_class.create(name: 'Default Bill', user: another_user)
        default_bill = described_class.new(name: 'Default Bill', user: current_user)

        expect(default_bill).to be_valid
      end
    end
  end
end
