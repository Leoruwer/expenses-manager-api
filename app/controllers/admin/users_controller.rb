# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    before_action :authorize_only_admin

    def index
      users = User.all

      render json: users, status: :ok
    end

    def show
      return render_not_found('User not found') if user.blank?

      render json: user, status: :ok
    end

    def update
      return render_not_found('User not found') if user.blank?

      if user.update(user_params)
        render json: { message: 'User updated with success' }, status: :ok
      else
        render json: { errors: user.errors.full_messages },
               status: :unprocessable_entity
      end
    end

    def destroy
      return render_not_found('User not found') if user.blank?

      user.destroy

      render json: { message: 'User deleted with success' }, status: :ok
    end

    private

    def user
      @user ||= User.find_by(slug: params[:slug])
    end

    def user_params
      params.permit(
        :name, :email, :password, :password_confirmation, :role
      )
    end
  end
end
