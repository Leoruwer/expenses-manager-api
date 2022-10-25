# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :request do
  describe '#create' do
    context 'with valid params' do
      it 'create normal user' do
        params = {
          user: {
            name: 'Foo Bar',
            username: 'foobar',
            email: 'foobar@mail.com',
            password: 'securepassword123',
            password_confirmation: 'securepassword123'
          }
        }

        post(users_path, params: params)

        json = JSON.parse(response.body)

        expect(response).to have_http_status :created
        expect(json['name']).to eq(params[:user][:name])
        expect(json['username']).to eq(params[:user][:username])
        expect(json['email']).to eq(params[:user][:email])
        expect(json['role']).to eq('user')
      end

      it 'create admin user' do
        params = {
          user: {
            name: 'Foo Bar',
            username: 'foobar',
            email: 'foobar@mail.com',
            password: 'securepassword123',
            password_confirmation: 'securepassword123',
            role: 'admin'
          }
        }

        post(users_path, params: params)

        json = JSON.parse(response.body)

        expect(response).to have_http_status :created
        expect(json['name']).to eq(params[:user][:name])
        expect(json['username']).to eq(params[:user][:username])
        expect(json['email']).to eq(params[:user][:email])
        expect(json['role']).to eq(params[:user][:role])
      end
    end

    context 'with invalid params' do
      it 'returns errors' do
        params = {
          user: {
            name: 'Foo bar'
          }
        }

        post(users_path, params: params)
        json = JSON.parse(response.body)

        expect(response).to have_http_status :unprocessable_entity
        expect(json['errors']).to include('Email can\'t be blank')
        expect(json['errors']).to include('Username can\'t be blank')
        expect(json['errors']).to include('Password can\'t be blank')
        expect(json['errors']).to include('Password is too short (minimum is 6 characters)')
      end
    end
  end

  describe '#auth_login' do
    let(:current_user) { create(:user) }

    it 'logins user' do
      params = {
        email: current_user.email,
        password: current_user.password
      }

      post(auth_login_path, params: params)

      json = JSON.parse(response.body)

      expect(json['username']).to eq(current_user.username)
      expect(JsonWebToken.decode(json['token'])['user_id']).to eq(current_user.id)
    end
  end

  context 'when JWT Token is valid' do
    let!(:current_user) { create(:user) }
    let!(:another_user) { create(:user, name: 'Second user', username: 'SecondUser', email: 'second.user@mail.com') }

    let(:jwt_token) do
      request_params = {
        email: current_user.email,
        password: current_user.password
      }

      post(auth_login_path, params: request_params)

      JSON.parse(response.body)['token']
    end

    describe '#index' do
      it 'returns all users' do
        get(users_path, headers: {'Authorization': jwt_token})
        json = JSON.parse(response.body)

        result = [
          {
            'name' => current_user.name,
            'username' => current_user.username,
            'email' => current_user.email,
            'role' => current_user.role
          },
          {
            'name' => another_user.name,
            'username' => another_user.username,
            'email' => another_user.email,
            'role' => another_user.role
          }
        ]

        expect(response).to have_http_status :ok
        expect(json.first).to include(result.first)
        expect(json.second).to include(result.second)
      end
    end

    describe '#show' do
      context 'with valid params' do
        it 'returns the given user' do
          get(user_path(current_user.username), headers: {'Authorization': jwt_token})
          json = JSON.parse(response.body)

          expect(response).to have_http_status :ok
          expect(json['name']).to eq(current_user.name)
          expect(json['username']).to eq(current_user.username)
          expect(json['email']).to eq(current_user.email)
          expect(json['role']).to eq(current_user.role)
        end
      end

      context 'with invalid params' do
        it 'returns errors' do
          get(user_path('invalid'), headers: {'Authorization': jwt_token})
          json = JSON.parse(response.body)

          expect(response).to have_http_status :not_found
          expect(json).to eq({'errors' => 'User not found'})
        end
      end
    end

    describe '#update' do
      context 'with valid params' do
        it 'updates the given user' do
          params = {
            user: {
              username: 'newUsername'
            }
          }

          put(user_path(current_user.username), headers: {'Authorization': jwt_token}, params: params)
          json = JSON.parse(response.body)

          expect(response).to have_http_status :ok
          expect(json['message']).to eq('User updated with success')
        end
      end

      context 'with invalid params' do
        it 'returns errors' do
          params = {
            user: {
              email: 'second.user@mail.com'
            }
          }

          put(user_path(current_user.username), headers: {'Authorization': jwt_token}, params: params)
          json = JSON.parse(response.body)

          expect(response).to have_http_status :unprocessable_entity
          expect(json['errors']).to include('Email has already been taken')
        end
      end
    end

    describe '#destroy' do
      it 'destroys the given user' do
        delete(user_path(current_user.username), headers: {'Authorization': jwt_token})

        expect(response).to have_http_status :ok
        expect{ current_user.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  context 'when JWT Token is invalid' do
    let(:current_user) { create(:user) }
    let(:jwt_token) { 'invalid-token' }

    describe '#index' do
      it 'returns invalid JWT token' do
        get(users_path, headers: {'Authorization': jwt_token})

        expect(response).to have_http_status :unauthorized
        expect(JSON.parse(response.body)).to include('message' => 'Invalid JWT token')
      end
    end

    describe '#show' do
      it 'returns invalid JWT token' do
        get(user_path(current_user.username), headers: {'Authorization': jwt_token})

        expect(response).to have_http_status :unauthorized
        expect(JSON.parse(response.body)).to include('message' => 'Invalid JWT token')
      end
    end

    describe '#update' do
      it 'returns invalid JWT token' do
        params = {
          username: 'newUsername'
        }

        put(user_path(current_user.username), headers: {'Authorization': jwt_token}, params: params)

        expect(response).to have_http_status :unauthorized
        expect(JSON.parse(response.body)).to include('message' => 'Invalid JWT token')
      end
    end

    describe '#destroy' do
      it 'returns invalid JWT token' do
        delete(user_path(current_user.username), headers: {'Authorization': jwt_token})

        expect(response).to have_http_status :unauthorized
        expect(JSON.parse(response.body)).to include('message' => 'Invalid JWT token')
      end
    end
  end
end
