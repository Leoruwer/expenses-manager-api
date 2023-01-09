# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'Unauthorize user that does not have admin role' do
  context 'when user is not admin' do
    let!(:current_user) { create(:user) }

    it 'returns Unauthorized' do
      subject

      expect(response).to have_http_status :unauthorized
      expect(json).to include({ 'message' => 'Unauthorized' })
    end
  end
end
