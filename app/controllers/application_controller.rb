# frozen_string_literal: true

class ApplicationController < ActionController::API
  def not_found
    render json: { error: 'not_found' }
  end

  def authorize_request
    current_user.present?
  rescue ActiveRecord::RecordNotFound, JWT::DecodeError => e
    Rails.logger.warn("Unauthorized user trying to log in: #{e.message}")
    render json: { message: 'Unauthorized' }, status: :unauthorized
  end

  def current_user
    @current_user ||= User.find(decoded_token[:user_id])
  end

  private

  def decoded_token
    header = request.headers['Authorization']
    header = header.split.last if header
    JsonWebToken.decode(header)
  end
end
