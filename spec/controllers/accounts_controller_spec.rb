# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccountsController, type: :request do
    let!(:current_user) { create(:user) }

    let!(:current_account) { create(:account, name: 'Account', user_id: current_user.id) }
    let(:another_account) { create(:account) }

    let(:jwt_token) { JsonWebToken.encode(user_id: current_user.id) }
    let(:json) { JSON.parse(response.body) }

    describe '#index' do
      subject { get(accounts_path, headers: { Authorization: jwt_token }) }

      it 'returns all accounts from current user' do
        subject

        expect(response).to have_http_status :ok
        expect(json.count).to eq(1)
        expect(json[0]['name']).to eq('Account')
      end

      include_examples 'Invalid JWT Token'
    end

    describe '#show' do
      subject { get(account_path(slug), headers: { Authorization: jwt_token }) }

      let(:slug) { current_account.slug }

      context 'with valid params' do
        it 'returns the given account' do
          subject

          expect(response).to have_http_status :ok
          expect(json['name']).to eq(current_account.name)
        end
      end

      context 'with invalid params' do
        let(:slug) { 'invalid-slug' }

        it 'returns errors' do
          subject

          expect(response).to have_http_status :not_found
          expect(json['errors']).to include('Account not found')
        end
      end

      context 'when account from another user' do
        let(:slug) { another_account.slug }

        it 'returns account not found' do
          subject

          expect(response).to have_http_status :not_found
          expect(json['errors']).to include('Account not found')
        end
      end

      include_examples 'Invalid JWT Token'
    end

    describe '#create' do
      subject { post(accounts_path, headers: { Authorization: jwt_token }, params: params) }

      let(:name) { 'New account name' }
      let(:params) do
        {
          name: name
        }
      end

      it 'creates a new account' do
        subject

        expect(response).to have_http_status :created
        expect(json).to include('message' => 'Account created with success')
      end

      context 'without name' do
        let(:name) { nil }

        it "returns name can't be blank error" do
          subject

          expect(json).to include('errors' => ["Name can't be blank"])
        end
      end

      include_examples 'Invalid JWT Token'
    end

    describe '#update' do
      subject { put(account_path(slug), headers: { Authorization: jwt_token }, params: params) }

      let(:slug) { current_account.slug }
      let(:name) { 'New account name' }
      let(:params) do
        {
          name: name
        }
      end

      it 'updates the given account' do
        subject

        expect(response).to have_http_status :ok
        expect(json['message']).to include('Account updated with success')
        expect(current_account.reload.name).to eq('New account name')
      end

      context 'when name is invalid' do
        let(:name) { nil }

        it "returns name can't be blank" do
          subject

          expect(response).to have_http_status :unprocessable_entity
          expect(json['errors']).to include("Name can't be blank")
        end
      end

      context 'when account from another user' do
        let(:slug) { another_account.slug }

        it 'returns account not found' do
          subject

          expect(response).to have_http_status :not_found
          expect(json['errors']).to include('Account not found')
        end
      end

      include_examples 'Invalid JWT Token'
    end

    describe '#destroy' do
      subject { delete(account_path(slug), headers: { Authorization: jwt_token }) }

      let(:slug) { current_account.slug }

      it 'destroys the given account' do
        subject

        expect(response).to have_http_status :ok
        expect { current_account.reload }.to raise_error(ActiveRecord::RecordNotFound)
        expect(json['message']).to include('Account deleted with success')
      end

      context 'with non existing account' do
        let(:slug) { 'non-existing-account' }

        it 'returns error' do
          subject

          expect(response).to have_http_status :not_found
          expect(json['errors']).to include('Account not found')
        end
      end

      context 'when account from another user' do
        let(:slug) { another_account.slug }

        it 'returns account not found' do
          subject

          expect(response).to have_http_status :not_found
          expect(json['errors']).to include('Account not found')
        end
      end

      include_examples 'Invalid JWT Token'
    end
end
