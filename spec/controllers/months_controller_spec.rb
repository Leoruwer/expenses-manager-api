# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MonthsController, type: :request do
  let!(:current_user) { create(:user) }

  let!(:current_month) { create(:month, name: 'Month', user_id: current_user.id) }
  let(:second_month) { create(:month) }

  let(:jwt_token) { JsonWebToken.encode(user_id: current_user.id) }
  let(:json) { JSON.parse(response.body) }

  describe '#index' do
    subject { get(months_path, headers: { Authorization: jwt_token }) }

    it 'returns all months from current user' do
      subject

      expect(response).to have_http_status :ok
      expect(json.count).to eq(1)
      expect(json[0]['name']).to eq('Month')
    end

    include_examples 'Invalid JWT Token'
  end

  describe '#show' do
    subject { get(month_path(slug), headers: { Authorization: jwt_token }) }

    let(:slug) { current_month.slug }

    context 'with valid params' do
      it 'returns the given month' do
        subject

        expect(response).to have_http_status :ok
        expect(json['name']).to eq(current_month.name)
      end
    end

    context 'with invalid params' do
      let(:slug) { 'invalid-slug' }

      it 'returns errors' do
        subject

        expect(response).to have_http_status :not_found
        expect(json).to include('errors' => 'Month not found')
      end
    end

    include_examples 'Invalid JWT Token'
  end

  describe '#create' do
    subject { post(months_path, headers: { Authorization: jwt_token }, params: params) }

    let(:name) { 'New month name' }
    let(:params) do
      {
        name: name,
      }
    end

    it 'creates a new month' do
      subject

      expect(response).to have_http_status :created
      expect(json).to include('message' => 'Month created with success')
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
    subject { put(month_path(current_month.slug), headers: { Authorization: jwt_token }, params: params) }

    let(:name) { 'New month name' }
    let(:params) do
      {
        name: name
      }
    end

    it 'updates the given month' do
      subject

      expect(response).to have_http_status :ok
      expect(json['message']).to eq('Month updated with success')
      expect(current_month.reload.name).to eq('New month name')
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

  describe '#destroy' do
    subject { delete(month_path(slug), headers: { Authorization: jwt_token }) }

    let(:slug) { current_month.slug }

    it 'destroys the given month' do
      subject

      expect(response).to have_http_status :ok
      expect { current_month.reload }.to raise_error(ActiveRecord::RecordNotFound)
      expect(json['message']).to include('Month deleted with success')
    end

    context 'with non existing month' do
      let(:slug) { 'non-existing-month' }

      it 'returns error' do
        subject

        expect(response).to have_http_status :not_found
        expect(json['errors']).to include('Month not found')
      end
    end

    include_examples 'Invalid JWT Token'
  end
end
