# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples "Invalid JWT Token" do
  context 'when JWT Token is invalid' do
    let(:jwt_token) { 'invalid-token' }

    it 'returns Unauthorized' do
      subject

      expect(response).to have_http_status :unauthorized
      expect(json).to include({ 'message' => 'Unauthorized' })
    end
  end
end
