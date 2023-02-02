# frozen_string_literal: true

class ApplicationController < ActionController::API
  def render_not_found(message = 'not found')
    render json: { errors: message }, status: :not_found
  end

  def authorize_user
    current_user.present?
  rescue ActiveRecord::RecordNotFound, JWT::DecodeError => e
    render_unauthorized("Unauthorized user trying to log in: #{e.message}")
  end

  def authorize_only_admin
    return true if current_user.admin?

    render_unauthorized("User id='#{current_user.id}' is trying to access unauthorized area")
  rescue ActiveRecord::RecordNotFound, JWT::DecodeError => e
    render_unauthorized("Unauthorized user trying to log in: #{e.message}")
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

  def render_unauthorized(message)
    Rails.logger.warn(message)

    render json: { message: 'Unauthorized' }, status: :unauthorized
  end
end
