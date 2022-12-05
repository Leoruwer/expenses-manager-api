# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CategoriesController, type: :request do
  describe '#categories_controller' do
    let!(:current_user) { create(:user) }
    let!(:another_user) { create(:user, name: 'Second user', slug: 'second-user-1', email: 'second.user@mail.com') }

    let!(:current_category) { create(:category, user_id: current_user.id) }
    let(:second_category) do
      create(:category, name: 'Second category', slug: 'second-category-2', user_id: another_user.id)
    end

    let(:jwt_token) do
      request_params = {
        email: current_user.email,
        password: current_user.password
      }

      post(auth_login_path, params: request_params)

      JSON.parse(response.body)['token']
    end

    describe '#index' do
      subject { get(categories_path, headers: { Authorization: jwt_token }, params: { user_id: user_id }) }

      let(:user_id) { current_user.id }

      it 'returns all categories from current user' do
        subject

        json = JSON.parse(response.body)

        expect(response).to have_http_status :ok
        expect(json.count).to eq(1)
        expect(json[0]['name']).to eq('Category')
      end

      context 'when JWT Token is invalid' do
        let(:jwt_token) { 'invalid-token' }

        it 'returns invalid JWT token' do
          subject

          json = JSON.parse(response.body)

          expect(response).to have_http_status :unauthorized
          expect(json).to include({ 'message' => 'Invalid JWT token' })
        end
      end

      context 'with invalid user' do
        let(:user_id) { nil }

        it 'returns no user found' do
          subject

          json = JSON.parse(response.body)

          expect(json).to include('errors' => 'User not found')
        end
      end
    end

    describe '#show' do
      subject { get(category_path(category_slug), headers: { Authorization: jwt_token }) }

      let(:category_slug) { current_category.slug }

      context 'with valid params' do
        it 'returns the given category' do
          subject

          json = JSON.parse(response.body)

          expect(response).to have_http_status :ok
          expect(json['name']).to eq(current_category.name)
        end
      end

      context 'with invalid params' do
        let(:category_slug) { 'invalid-slug' }

        it 'returns errors' do
          subject

          json = JSON.parse(response.body)

          expect(response).to have_http_status :not_found
          expect(json).to include('errors' => 'Category not found')
        end
      end

      context 'when JWT Token is invalid' do
        let(:jwt_token) { 'invalid-token' }

        it 'returns invalid JWT token' do
          subject

          json = JSON.parse(response.body)

          expect(response).to have_http_status :unauthorized
          expect(json).to include('message' => 'Invalid JWT token')
        end
      end
    end

    describe '#create' do
      subject { post(categories_path, headers: { Authorization: jwt_token }, params: params) }

      let(:name) { 'New category name' }
      let(:user_id) { current_user.id }
      let(:params) do
        {
          name: name,
          user_id: user_id
        }
      end

      it 'creates a new category' do
        subject

        json = JSON.parse(response.body)

        expect(response).to have_http_status :created
        expect(json).to include('message' => 'Category created with success')
      end

      context 'without name' do
        let(:name) { nil }

        it "returns name can't be blank error" do
          subject

          json = JSON.parse(response.body)

          expect(json).to include('errors' => ["Name can't be blank"])
        end
      end

      context 'with invalid user' do
        let(:user_id) { nil }

        it 'returns no user found' do
          subject

          json = JSON.parse(response.body)

          expect(json).to include('errors' => 'User not found')
        end
      end
    end

    describe '#update' do
      subject { put(category_path(current_category.slug), headers: { Authorization: jwt_token }, params: params) }

      let(:name) { 'New category name' }
      let(:user_id) { current_user.id }
      let(:params) do
        {
          user_id: user_id,
          name: name
        }
      end

      it 'updates the given category' do
        subject

        json = JSON.parse(response.body)

        expect(response).to have_http_status :ok
        expect(json['message']).to eq('Category updated with success')
        expect(current_category.reload.name).to eq('New category name')
      end

      context 'when JWT Token is invalid' do
        let(:jwt_token) { 'invalid-token' }

        it 'returns invalid JWT token' do
          subject

          expect(response).to have_http_status :unauthorized
          expect(JSON.parse(response.body)).to include('message' => 'Invalid JWT token')
        end
      end

      context 'with invalid user' do
        let(:user_id) { nil }

        it 'returns no user found' do
          subject

          json = JSON.parse(response.body)

          expect(json).to include('errors' => 'User not found')
        end
      end
    end

    describe '#destroy' do
      subject { delete(category_path(params), headers: { Authorization: jwt_token }) }

      let(:params) { current_category.slug }

      it 'destroys the given category' do
        subject

        json = JSON.parse(response.body)

        expect(response).to have_http_status :ok
        expect { current_category.reload }.to raise_error(ActiveRecord::RecordNotFound)
        expect(json['message']).to include('Category deleted with success')
      end

      context 'with non existing category' do
        let(:params) { 'non-existing-category' }

        it 'returns error' do
          subject

          json = JSON.parse(response.body)

          expect(response).to have_http_status :not_found
          expect(json['errors']).to include('Category not found')
        end
      end

      context 'when JWT Token is invalid' do
        let(:jwt_token) { 'invalid-token' }

        it 'returns invalid JWT token' do
          subject

          expect(response).to have_http_status :unauthorized
          expect(JSON.parse(response.body)).to include('message' => 'Invalid JWT token')
        end
      end
    end
  end
end
