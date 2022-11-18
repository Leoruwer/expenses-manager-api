# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :request do
  describe '#create' do
    subject { post(register_path, params: params) }

    let(:name) { 'Foo Bar' }
    let(:email) { 'foobar@mail.com' }
    let(:password) { 'securepassword123' }
    let(:role) { 'user' }
    let(:params) do
      {
        name: name,
        email: email,
        password: password,
        password_confirmation: password,
        role: role
      }
    end

    context 'with valid params' do
      it 'create normal user' do
        subject

        json = JSON.parse(response.body)

        expect(response).to have_http_status :created
        expect(json['name']).to eq('Foo Bar')
        expect(json['email']).to eq('foobar@mail.com')
        expect(json['role']).to eq('user')
      end

      context 'when role is admin' do
        let(:role) { 'admin' }
        it 'creates a user' do
          subject

          json = JSON.parse(response.body)

          expect(response).to have_http_status :created
          expect(json['name']).to eq('Foo Bar')
          expect(json['email']).to eq('foobar@mail.com')
          expect(json['role']).to eq('admin')
        end
      end
    end

    context 'with invalid params' do
      context 'with blank email' do
        let(:email) { nil }

        it 'returns error' do
          subject

          json = JSON.parse(response.body)

          expect(response).to have_http_status :unprocessable_entity
          expect(json['errors']).to include('Email can\'t be blank')
        end
      end

      context 'with invalid email' do
        let(:email) { 'invalidmail' }

        it 'returns error' do
          subject

          json = JSON.parse(response.body)

          expect(response).to have_http_status :unprocessable_entity
          expect(json['errors']).to include('Email is invalid')
        end
      end

      context 'with blank name' do
        let(:name) { nil }

        it 'returns error' do
          subject

          json = JSON.parse(response.body)

          expect(response).to have_http_status :unprocessable_entity
          expect(json['errors']).to include('Name can\'t be blank')
        end
      end

      context 'with blank password' do
        let(:password) { nil }

        it 'returns error' do
          subject

          json = JSON.parse(response.body)

          expect(response).to have_http_status :unprocessable_entity
          expect(json['errors']).to include('Password can\'t be blank')
        end
      end

      context 'with short password' do
        let(:password) { '12345' }

        it 'returns error' do
          subject

          json = JSON.parse(response.body)

          expect(response).to have_http_status :unprocessable_entity
          expect(json['errors']).to include('Password is too short (minimum is 6 characters)')
        end
      end
    end
  end
end
