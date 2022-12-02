# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccountsController, type: :request do
  describe '#accounts_controller' do
    let!(:current_user) { create(:user) }
    let!(:another_user) { create(:user, name: 'Second user', slug: 'second-user-1', email: 'second.user@mail.com') }

    let!(:current_account) { create(:account, user_id: current_user.id) }
    let(:second_account) do
      create(:account, name: 'Second account', slug: 'second-account-2', user_id: another_user.id)
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
      subject { get(accounts_path, headers: { Authorization: jwt_token }, params: { user_id: user_id }) }

      let(:user_id) { current_user.id }

      it 'returns all accounts from current user' do
        subject

        json = JSON.parse(response.body)

        expect(response).to have_http_status :ok
        expect(json.count).to eq(1)
        expect(json[0]['name']).to eq('Account')
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
      subject { get(account_path(account_slug), headers: { Authorization: jwt_token }) }

      let(:account_slug) { current_account.slug }

      context 'with valid params' do
        it 'returns the given account' do
          subject

          json = JSON.parse(response.body)

          expect(response).to have_http_status :ok
          expect(json['name']).to eq(current_account.name)
        end
      end

      context 'with invalid params' do
        let(:account_slug) { 'invalid-slug' }

        it 'returns errors' do
          subject

          json = JSON.parse(response.body)

          expect(response).to have_http_status :not_found
          expect(json).to include('errors' => 'Account not found')
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
      subject { post(accounts_path, headers: { Authorization: jwt_token }, params: params) }

      let(:name) { 'New account name' }
      let(:user_id) { current_user.id }
      let(:params) do
        {
          user_id: user_id,
          name: name
        }
      end

      it 'creates a new account' do
        subject

        json = JSON.parse(response.body)

        expect(response).to have_http_status :created
        expect(json).to include('message' => 'Account created with success')
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
      subject { put(account_path(current_account.slug), headers: { Authorization: jwt_token }, params: params) }

      let(:name) { 'New account name' }
      let(:user_id) { current_user.id }
      let(:params) do
        {
          user_id: user_id,
          name: name
        }
      end

      it 'updates the given account' do
        subject

        json = JSON.parse(response.body)

        expect(response).to have_http_status :ok
        expect(json['message']).to eq('Account updated with success')
        expect(current_account.reload.name).to eq('New account name')
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
      subject { delete(account_path(params), headers: { Authorization: jwt_token }) }

      let(:params) { current_account.slug }

      it 'destroys the given account' do
        subject

        json = JSON.parse(response.body)

        expect(response).to have_http_status :ok
        expect { current_account.reload }.to raise_error(ActiveRecord::RecordNotFound)
        expect(json['message']).to include('Account deleted with success')
      end

      context 'with non existing account' do
        let(:params) { 'non-existing-account' }

        it 'returns error' do
          subject

          json = JSON.parse(response.body)

          expect(response).to have_http_status :not_found
          expect(json['errors']).to include('Account not found')
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
