# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Category do
  let!(:current_user) { create(:user) }

  it 'is valid with valid params' do
    expect(described_class.new(name: 'Category', user: current_user)).to be_valid
  end

  it 'generates slug' do
    category = described_class.create(name: 'Category name', user: current_user)

    expect(category.slug).to match('category-name')
  end

  describe 'model validations' do
    it 'validates name presence' do
      category = described_class.new(name: nil, user: current_user)

      expect(category).not_to be_valid
    end
  end
end
