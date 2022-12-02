# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::AccountsController, type: :request do
  describe '#accounts_controller' do
    let!(:user) { create(:user) }
    let!(:current_account) { create(:account, user_id: user.id) }

    let(:jwt_token) do
      request_params = {
        email: user.email,
        password: user.password
      }

      post(auth_login_path, params: request_params)

      JSON.parse(response.body)['token']
    end

    describe '#index' do
      subject { get(admin_accounts_path, headers: { Authorization: jwt_token }) }

      it 'returns all accounts' do
        subject

        json = JSON.parse(response.body)

        expect(response).to have_http_status :ok
        expect(json[0]['name']).to eq('Account')
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
      subject { get(admin_account_path(params), headers: { Authorization: jwt_token }) }

      let(:params) { current_account.slug }

      context 'with valid params' do
        it 'returns the given account' do
          subject

          json = JSON.parse(response.body)

          expect(response).to have_http_status :ok
          expect(json['name']).to eq(current_account.name)
        end
      end

      context 'with invalid params' do
        let(:params) { 'invalid-slug' }

        it 'returns errors' do
          subject

          json = JSON.parse(response.body)

          expect(response).to have_http_status :not_found
          expect(json).to eq({ 'errors' => 'Account not found' })
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
      subject { put(admin_account_path(current_account.slug), headers: { Authorization: jwt_token }, params: params) }

      let(:name) { 'New account name' }
      let(:params) do
        {
          name: name
        }
      end

      context 'with valid params' do
        it 'updates the given account' do
          subject

          json = JSON.parse(response.body)

          expect(response).to have_http_status :ok
          expect(json['message']).to eq('Account updated with success')
          expect(current_account.reload.name).to eq('New account name')
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
      subject { delete(admin_account_path(params), headers: { Authorization: jwt_token }) }

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
