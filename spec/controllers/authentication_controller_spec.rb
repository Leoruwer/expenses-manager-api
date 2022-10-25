# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuthenticationController, type: :request do
  describe '#auth_login' do
    let(:current_user) { create(:user) }

    context 'with the correct info' do
      it 'logins user' do
        params = {
          email: current_user.email,
          password: current_user.password
        }

        post(auth_login_path, params: params)
        json = JSON.parse(response.body)

        expect(response).to have_http_status :ok
        expect(json['username']).to eq(current_user.username)
        expect(JsonWebToken.decode(json['token'])['user_id']).to eq(current_user.id)
      end
    end

    context 'with the incorrect info' do
      it 'returns error' do
        params = {
          email: 'incorrect@mail.com',
          password: 'incorrectPassword'
        }

        post(auth_login_path, params: params)
        json = JSON.parse(response.body)

        expect(response).to have_http_status :unauthorized
        expect(json['message']).to include('Incorrect info provided')
        expect(json['error']).to include('unauthorized')
      end
    end
  end

end
