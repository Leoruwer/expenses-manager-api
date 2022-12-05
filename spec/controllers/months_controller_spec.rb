# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MonthsController, type: :request do
  describe '#months_controller' do
    let!(:current_user) { create(:user) }
    let!(:another_user) { create(:user, name: 'Second user', slug: 'second-user-1', email: 'second.user@mail.com') }

    let!(:current_month) { create(:month, user_id: current_user.id) }
    let(:second_month) do
      create(:month, name: 'Second month', slug: 'second-month-2', user_id: another_user.id)
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
      subject { get(months_path, headers: { Authorization: jwt_token }, params: { user_id: user_id }) }

      let(:user_id) { current_user.id }

      it 'returns all months from current user' do
        subject

        json = JSON.parse(response.body)

        expect(response).to have_http_status :ok
        expect(json.count).to eq(1)
        expect(json[0]['name']).to eq('Month')
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
      subject { get(month_path(month_slug), headers: { Authorization: jwt_token }) }

      let(:month_slug) { current_month.slug }

      context 'with valid params' do
        it 'returns the given month' do
          subject

          json = JSON.parse(response.body)

          expect(response).to have_http_status :ok
          expect(json['name']).to eq(current_month.name)
        end
      end

      context 'with invalid params' do
        let(:month_slug) { 'invalid-slug' }

        it 'returns errors' do
          subject

          json = JSON.parse(response.body)

          expect(response).to have_http_status :not_found
          expect(json).to include('errors' => 'Month not found')
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
      subject { post(months_path, headers: { Authorization: jwt_token }, params: params) }

      let(:name) { 'New month name' }
      let(:user_id) { current_user.id }
      let(:params) do
        {
          name: name,
          user_id: user_id
        }
      end

      it 'creates a new month' do
        subject

        json = JSON.parse(response.body)

        expect(response).to have_http_status :created
        expect(json).to include('message' => 'Month created with success')
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
      subject { put(month_path(current_month.slug), headers: { Authorization: jwt_token }, params: params) }

      let(:name) { 'New month name' }
      let(:user_id) { current_user.id }
      let(:params) do
        {
          user_id: user_id,
          name: name
        }
      end

      it 'updates the given month' do
        subject

        json = JSON.parse(response.body)

        expect(response).to have_http_status :ok
        expect(json['message']).to eq('Month updated with success')
        expect(current_month.reload.name).to eq('New month name')
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
      subject { delete(month_path(params), headers: { Authorization: jwt_token }) }

      let(:params) { current_month.slug }

      it 'destroys the given month' do
        subject

        json = JSON.parse(response.body)

        expect(response).to have_http_status :ok
        expect { current_month.reload }.to raise_error(ActiveRecord::RecordNotFound)
        expect(json['message']).to include('Month deleted with success')
      end

      context 'with non existing month' do
        let(:params) { 'non-existing-month' }

        it 'returns error' do
          subject

          json = JSON.parse(response.body)

          expect(response).to have_http_status :not_found
          expect(json['errors']).to include('Month not found')
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
