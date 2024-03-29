# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CategoriesController, type: :request do
  let!(:current_user) { create(:user) }

  let!(:current_category) { create(:category, name: 'Category', user_id: current_user.id) }
  let(:another_category) { create(:category) }

  let(:jwt_token) { JsonWebToken.encode(user_id: current_user.id) }
  let(:json) { JSON.parse(response.body) }

  describe '#index' do
    subject { get(categories_path, headers: { Authorization: jwt_token }) }

    it 'returns all categories from current user' do
      subject

      expect(response).to have_http_status :ok
      expect(json.count).to eq(1)
      expect(json[0]['name']).to eq('Category')
    end

    include_examples 'Invalid JWT Token'
  end

  describe '#show' do
    subject { get(category_path(slug), headers: { Authorization: jwt_token }) }

    let(:slug) { current_category.slug }

    context 'with valid params' do
      it 'returns the given category' do
        subject

        expect(response).to have_http_status :ok
        expect(json['name']).to eq(current_category.name)
      end
    end

    context 'with invalid params' do
      let(:slug) { 'invalid-slug' }

      it 'returns errors' do
        subject

        expect(response).to have_http_status :not_found
        expect(json['errors']).to include('Category not found')
      end
    end

    context 'when category from another user' do
      let(:slug) { another_category.slug }

      it 'returns category not found' do
        subject

        expect(response).to have_http_status :not_found
        expect(json['errors']).to include('Category not found')
      end
    end

    include_examples 'Invalid JWT Token'
  end

  describe '#create' do
    subject { post(categories_path, headers: { Authorization: jwt_token }, params: params) }

    let(:name) { 'New category name' }
    let(:params) { { name: name } }

    it 'creates a new category' do
      subject

      expect(response).to have_http_status :created
      expect(json['message']).to include('Category created with success')
    end

    context 'without name' do
      let(:name) { nil }

      it "returns name can't be blank error" do
        subject

        expect(json['errors']).to include("Name can't be blank")
      end
    end

    describe 'validates name uniqueness' do
      context 'when the user has category with same name' do
        let!(:existing_category) { create(:category, user: current_user) }
        let(:name) { existing_category.name }

        it 'is not valid' do
          subject

          expect(json['errors']).to include('Name has already been taken')
        end
      end

      context 'when another user has category with same name' do
        let!(:another_user) { create(:user) }
        let!(:existing_category) { create(:category, user: another_user) }
        let(:name) { existing_category.name }

        it 'is valid' do
          subject

          expect(json['message']).to include('Category created with success')
        end
      end
    end

    include_examples 'Invalid JWT Token'
  end

  describe '#update' do
    subject { put(category_path(slug), headers: { Authorization: jwt_token }, params: params) }

    let(:slug) { current_category.slug }
    let(:name) { 'New category name' }
    let(:params) { { name: name } }

    it 'updates the given category' do
      subject

      expect(response).to have_http_status :ok
      expect(json['message']).to include('Category updated with success')
      expect(current_category.reload.name).to eq('New category name')
    end

    context 'when name is invalid' do
      let(:name) { nil }

      it "returns name can't be blank" do
        subject

        expect(response).to have_http_status :unprocessable_entity
        expect(json['errors']).to include("Name can't be blank")
      end
    end

    context 'when category from another user' do
      let(:slug) { another_category.slug }

      it 'returns category not found' do
        subject

        expect(response).to have_http_status :not_found
        expect(json['errors']).to include('Category not found')
      end
    end

    include_examples 'Invalid JWT Token'
  end

  describe '#destroy' do
    subject { delete(category_path(slug), headers: { Authorization: jwt_token }) }

    let(:slug) { current_category.slug }

    it 'destroys the given category' do
      subject

      expect(response).to have_http_status :ok
      expect { current_category.reload }.to raise_error(ActiveRecord::RecordNotFound)
      expect(json['message']).to include('Category deleted with success')
    end

    context 'with non existing category' do
      let(:slug) { 'non-existing-category' }

      it 'returns error' do
        subject

        expect(response).to have_http_status :not_found
        expect(json['errors']).to include('Category not found')
      end
    end

    context 'when category from another user' do
      let(:slug) { another_category.slug }

      it 'returns category not found' do
        subject

        expect(response).to have_http_status :not_found
        expect(json['errors']).to include('Category not found')
      end
    end

    include_examples 'Invalid JWT Token'
  end
end
