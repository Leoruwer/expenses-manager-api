# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DefaultBillsController, type: :request do
  let!(:current_user) { create(:user) }
  let!(:another_user) { create(:user, name: 'Second user', slug: 'second-user-1', email: 'second.user@mail.com') }

  let!(:current_default_bill) { create(:default_bill, user_id: current_user.id) }
  let(:second_default_bill) do
    create(:default_bill, name: 'Second default bill', slug: 'second-default_bill-2', user_id: another_user.id)
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
    subject { get(default_bills_path, headers: { Authorization: jwt_token }) }

    it 'returns all default bills from current user' do
      subject

      json = JSON.parse(response.body)

      expect(response).to have_http_status :ok
      expect(json.count).to eq(1)
      expect(json[0]['name']).to eq('Default Bill')
      expect(json[0]['value']).to eq(100)
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
  end

  describe '#show' do
    subject { get(default_bill_path(default_bill_slug), headers: { Authorization: jwt_token }) }

    let(:default_bill_slug) { current_default_bill.slug }

    context 'with valid params' do
      it 'returns the given default bill' do
        subject

        json = JSON.parse(response.body)

        expect(response).to have_http_status :ok
        expect(json['name']).to eq('Default Bill')
        expect(json['value']).to eq(100)
      end
    end

    context 'with invalid params' do
      let(:default_bill_slug) { 'invalid-slug' }

      it 'returns errors' do
        subject

        json = JSON.parse(response.body)

        expect(response).to have_http_status :not_found
        expect(json).to include('errors' => 'Default Bill not found')
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
    subject { post(default_bills_path, headers: { Authorization: jwt_token }, params: params) }

    let(:name) { 'New default bill name' }
    let(:params) do
      {
        name: name,
        value: 150
      }
    end

    it 'creates a new default_bill' do
      subject

      json = JSON.parse(response.body)

      expect(response).to have_http_status :created
      expect(json).to include('message' => 'Default Bill created with success')
    end

    context 'without name' do
      let(:name) { nil }

      it "returns name can't be blank error" do
        subject

        json = JSON.parse(response.body)

        expect(json).to include('errors' => ["Name can't be blank"])
      end
    end
  end

  describe '#update' do
    subject do
      put(default_bill_path(current_default_bill.slug), headers: { Authorization: jwt_token }, params: params)
    end

    let(:name) { 'New default bill name' }
    let(:params) do
      {
        name: name
      }
    end

    it 'updates the given default bill' do
      subject

      json = JSON.parse(response.body)

      expect(response).to have_http_status :ok
      expect(json['message']).to eq('Default Bill updated with success')
      expect(current_default_bill.reload.name).to eq('New default bill name')
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
    subject { delete(default_bill_path(params), headers: { Authorization: jwt_token }) }

    let(:params) { current_default_bill.slug }

    it 'destroys the given default bill' do
      subject

      json = JSON.parse(response.body)

      expect(response).to have_http_status :ok
      expect { current_default_bill.reload }.to raise_error(ActiveRecord::RecordNotFound)
      expect(json['message']).to include('Default Bill deleted with success')
    end

    context 'with non existing default_bill' do
      let(:params) { 'non-existing-default_bill' }

      it 'returns error' do
        subject

        json = JSON.parse(response.body)

        expect(response).to have_http_status :not_found
        expect(json['errors']).to include('Default Bill not found')
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