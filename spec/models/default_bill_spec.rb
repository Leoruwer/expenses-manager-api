# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DefaultBill do
  let!(:current_user) { create(:user) }

  it 'is valid with valid params' do
    expect(described_class.new(name: 'Default Bill', user: current_user)).to be_valid
  end

  it 'generates slug' do
    default_bill = described_class.create(name: 'Default Bill', user: current_user)

    expect(default_bill.slug).to match(/default-bill-.*/)
  end

  describe 'model validations' do
    it 'validates name presence' do
      default_bill = described_class.new(name: nil, user: current_user)

      expect(default_bill).not_to be_valid
    end
  end
end
