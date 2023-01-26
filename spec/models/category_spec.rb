# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Category do
  let!(:current_user) { create(:user) }

  context 'with valid params' do
    it 'is valid' do
      category = described_class.new(name: 'Category', user: current_user)

      expect(category).to be_valid
    end

    it 'generates slug' do
      category = described_class.create(name: 'Category name', user: current_user)

      expect(category.slug).to match('category-name')
    end
  end

  describe 'model validations' do
    it 'validates name presence' do
      category = described_class.new(name: nil, user: current_user)

      expect(category).not_to be_valid
    end

    describe 'validates name uniqueness' do
      let!(:another_user) { create(:user) }

      it 'is not valid when the user has category with same name' do
        described_class.create(name: 'Category', user: current_user)
        category = described_class.new(name: 'Category', user: current_user)

        expect(category).not_to be_valid
      end

      it 'is valid when another user has category with same name' do
        described_class.create(name: 'Category', user: another_user)
        category = described_class.new(name: 'Category', user: current_user)

        expect(category).to be_valid
      end
    end
  end
end
