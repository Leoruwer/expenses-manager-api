# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe Expense do
  let!(:current_user) { create(:user) }

  let(:category) { create(:category) }
  let(:account) { create(:account) }

  context 'with valid params' do
    it 'is valid' do
      expense = described_class.new(name: 'Expense', account: account, category: category, user: current_user)

      expect(expense).to be_valid
    end

    it 'generates slug' do
      expense = described_class.create(name: 'Expense Name', account: account, category: category, user: current_user)

      expect(expense.slug).to match('expense-name')
    end
  end

  describe 'with invalid params' do
    it 'validates name presence' do
      expense = described_class.new(name: nil, account: account, category: category, user: current_user)

      expect(expense).not_to be_valid
    end

    it 'validates account presence' do
      expense = described_class.new(name: 'Expense', account: nil, category: category, user: current_user)

      expect(expense).not_to be_valid
    end

    it 'validates category presence' do
      expense = described_class.new(name: 'Expense', account: account, category: nil, user: current_user)

      expect(expense).not_to be_valid
    end

    describe 'validates name uniqueness' do
      let!(:another_user) { create(:user) }

      it 'is not valid when the user has expense with same name' do
        described_class.create(name: 'Expense', account: account, category: category, user: current_user)
        expense = described_class.new(name: 'Expense', user: current_user)

        expect(expense).not_to be_valid
      end

      it 'is valid when another user has expense with same name' do
        described_class.create(name: 'Expense', account: account, category: category, user: another_user)
        expense = described_class.new(name: 'Expense', account: account, category: category, user: current_user)

        expect(expense).to be_valid
      end
    end
  end
end
