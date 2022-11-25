# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::UsersController, type: :request do
  context 'when JWT Token is valid' do
    let!(:current_user) { create(:user) }
    let!(:another_user) { create(:user, name: 'Second user', slug: 'second-user-1', email: 'second.user@mail.com') }

    let(:jwt_token) do
      request_params = {
        email: current_user.email,
        password: current_user.password
      }

      post(auth_login_path, params: request_params)

      JSON.parse(response.body)['token']
    end

    describe '#index' do
      subject { get(admin_users_path, headers: {'Authorization': jwt_token}) }

      it 'returns all users' do
        subject

        json = JSON.parse(response.body)

        expect(response).to have_http_status :ok
        expect(json[0]['email']).to eq(current_user.email)
        expect(json[1]['email']).to eq(another_user.email)
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

    describe '#show' do
      let(:params) { current_user.slug }
      subject { get(admin_user_path(params), headers: {'Authorization': jwt_token}) }

      context 'with valid params' do
        it 'returns the given user' do
          subject

          json = JSON.parse(response.body)

          expect(response).to have_http_status :ok
          expect(json['name']).to eq(current_user.name)
          expect(json['email']).to eq(current_user.email)
          expect(json['role']).to eq(current_user.role)
        end
      end

      context 'with invalid params' do
        let(:params) { 'invalid-slug' }

        it 'returns errors' do
          subject

          json = JSON.parse(response.body)

          expect(response).to have_http_status :not_found
          expect(json).to eq({'errors' => 'User not found'})
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

    describe '#update' do
      subject { put(admin_user_path(current_user.slug), headers: {'Authorization': jwt_token}, params: params) }

      let(:email) { 'new-foobar@mail.com' }
      let(:params) do
        {
          email: email
        }
      end

      context 'with valid params' do
        it 'updates the given user' do
          subject

          json = JSON.parse(response.body)

          expect(response).to have_http_status :ok
          expect(json['message']).to eq('User updated with success')
          expect(current_user.reload.email).to eq('new-foobar@mail.com')
        end
      end

      context 'with invalid params' do
        let(:email) { 'second.user@mail.com' }

        it 'returns errors' do
          subject

          json = JSON.parse(response.body)

          expect(response).to have_http_status :unprocessable_entity
          expect(json['errors']).to include('Email has already been taken')
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

    describe '#destroy' do
      subject { delete(admin_user_path(params), headers: {'Authorization': jwt_token}) }

      context 'with existing user' do
        let(:params) { current_user.slug }

        it 'destroys the given user' do
          subject

          json = JSON.parse(response.body)

          expect(response).to have_http_status :ok
          expect{ current_user.reload }.to raise_error(ActiveRecord::RecordNotFound)
          expect(json['message']).to include('User deleted with success')
        end
      end

      context 'with non existing user' do
        let(:params) { 'non-existing-user' }

        it 'returns error' do
          subject

          json = JSON.parse(response.body)

          expect(response).to have_http_status :not_found
          expect(json['errors']).to include('User not found')
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
end
