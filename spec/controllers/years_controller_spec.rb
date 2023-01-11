# frozen_string_literal: true

require 'rails_helper'

RSpec.describe YearsController, type: :request do
  let!(:current_user) { create(:user) }

  let!(:current_year) { create(:year, name: 'Year', user_id: current_user.id) }
  let(:another_year) { create(:year) }

  let(:jwt_token) { JsonWebToken.encode(user_id: current_user.id) }
  let(:json) { JSON.parse(response.body) }

  describe '#index' do
    subject { get(years_path, headers: { Authorization: jwt_token }) }

    it 'returns all years from current user' do
      subject

      expect(response).to have_http_status :ok
      expect(json.count).to eq(1)
      expect(json[0]['name']).to eq('Year')
    end

    include_examples 'Invalid JWT Token'
  end

  describe '#show' do
    subject { get(year_path(slug), headers: { Authorization: jwt_token }) }

    let(:slug) { current_year.slug }

    context 'with valid params' do
      it 'returns the given year' do
        subject

        expect(response).to have_http_status :ok
        expect(json['name']).to eq('Year')
      end
    end

    context 'with invalid slug' do
      let(:slug) { 'invalid-slug' }

      it 'returns year not found' do
        subject

        expect(response).to have_http_status :not_found
        expect(json['errors']).to include('Year not found')
      end
    end

    context 'when year from another user' do
      let(:slug) { another_year.slug }

      it 'returns year not found' do
        subject

        expect(response).to have_http_status :not_found
        expect(json['errors']).to include('Year not found')
      end
    end

    include_examples 'Invalid JWT Token'
  end

  describe '#create' do
    subject { post(years_path, headers: { Authorization: jwt_token }, params: params) }

    let(:name) { 'New year name' }
    let(:params) do
      {
        name: name
      }
    end

    it 'creates a new year' do
      subject

      expect(response).to have_http_status :created
      expect(json).to include('message' => 'Year created with success')
    end

    context 'without name' do
      let(:name) { nil }

      it "returns name can't be blank error" do
        subject

        expect(json).to include('errors' => ["Name can't be blank"])
      end
    end
  end

  describe '#update' do
    subject { put(year_path(slug), headers: { Authorization: jwt_token }, params: params) }

    let(:slug) { current_year.slug }
    let(:name) { 'New year name' }
    let(:params) do
      {
        name: name
      }
    end

    it 'updates the given year' do
      subject

      expect(response).to have_http_status :ok
      expect(json['message']).to eq('Year updated with success')
      expect(current_year.reload.name).to eq('New year name')
    end

    context 'without name' do
      let(:name) { nil }

      it "returns name can't be blank error" do
        subject

        expect(json['errors']).to include("Name can't be blank")
      end
    end

    context 'when year from another user' do
      let(:slug) { another_year.slug }

      it 'returns year not found' do
        subject

        expect(response).to have_http_status :not_found
        expect(json['errors']).to include('Year not found')
      end
    end

    include_examples 'Invalid JWT Token'
  end

  describe '#destroy' do
    subject { delete(year_path(slug), headers: { Authorization: jwt_token }) }

    let(:slug) { current_year.slug }

    it 'destroys the given year' do
      subject

      expect(response).to have_http_status :ok
      expect { current_year.reload }.to raise_error(ActiveRecord::RecordNotFound)
      expect(json['message']).to include('Year deleted with success')
    end

    context 'with non existing year' do
      let(:slug) { 'non-existing-year' }

      it 'returns error' do
        subject

        expect(response).to have_http_status :not_found
        expect(json['errors']).to include('Year not found')
      end
    end

    context 'when year from another user' do
      let(:slug) { another_year.slug }

      it 'returns year not found' do
        subject

        expect(response).to have_http_status :not_found
        expect(json['errors']).to include('Year not found')
      end
    end

    include_examples 'Invalid JWT Token'
  end
end
