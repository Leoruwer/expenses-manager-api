# frozen_string_literal: true

require 'rails_helper'

RSpec.describe YearsController, type: :request do
  describe '#years_controller' do
    let!(:current_user) { create(:user) }
    let!(:another_user) { create(:user, name: 'Second user', slug: 'second-user-1', email: 'second.user@mail.com') }

    let!(:current_year) { create(:year, user_id: current_user.id) }
    let(:second_year) do
      create(:year, name: 'Second year', slug: 'second-year-2', user_id: another_user.id)
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
      subject { get(years_path, headers: { Authorization: jwt_token }, params: { user_id: user_id }) }

      let(:user_id) { current_user.id }

      it 'returns all years from current user' do
        subject

        json = JSON.parse(response.body)

        expect(response).to have_http_status :ok
        expect(json.count).to eq(1)
        expect(json[0]['name']).to eq('Year')
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
      subject { get(year_path(year_slug), headers: { Authorization: jwt_token }) }

      let(:year_slug) { current_year.slug }

      context 'with valid params' do
        it 'returns the given year' do
          subject

          json = JSON.parse(response.body)

          expect(response).to have_http_status :ok
          expect(json['name']).to eq(current_year.name)
        end
      end

      context 'with invalid params' do
        let(:year_slug) { 'invalid-slug' }

        it 'returns errors' do
          subject

          json = JSON.parse(response.body)

          expect(response).to have_http_status :not_found
          expect(json).to include('errors' => 'Year not found')
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
      subject { post(years_path, headers: { Authorization: jwt_token }, params: params) }

      let(:name) { 'New year name' }
      let(:user_id) { current_user.id }
      let(:params) do
        {
          name: name,
          user_id: user_id
        }
      end

      it 'creates a new year' do
        subject

        json = JSON.parse(response.body)

        expect(response).to have_http_status :created
        expect(json).to include('message' => 'Year created with success')
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
      subject { put(year_path(current_year.slug), headers: { Authorization: jwt_token }, params: params) }

      let(:name) { 'New year name' }
      let(:user_id) { current_user.id }
      let(:params) do
        {
          user_id: user_id,
          name: name
        }
      end

      it 'updates the given year' do
        subject

        json = JSON.parse(response.body)

        expect(response).to have_http_status :ok
        expect(json['message']).to eq('Year updated with success')
        expect(current_year.reload.name).to eq('New year name')
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
      subject { delete(year_path(params), headers: { Authorization: jwt_token }) }

      let(:params) { current_year.slug }

      it 'destroys the given year' do
        subject

        json = JSON.parse(response.body)

        expect(response).to have_http_status :ok
        expect { current_year.reload }.to raise_error(ActiveRecord::RecordNotFound)
        expect(json['message']).to include('Year deleted with success')
      end

      context 'with non existing year' do
        let(:params) { 'non-existing-year' }

        it 'returns error' do
          subject

          json = JSON.parse(response.body)

          expect(response).to have_http_status :not_found
          expect(json['errors']).to include('Year not found')
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
