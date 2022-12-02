# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    before_action :authorize_request
    before_action :find_user, except: %i[index]

    def index
      users = User.all

      render json: users, status: :ok
    end

    def show
      render json: @user, status: :ok
    end

    def update
      if @user.update(user_params)
        render json: { message: 'User updated with success' }, status: :ok
      else
        render json: { errors: @user.errors.full_messages },
               status: :unprocessable_entity
      end
    end

    def destroy
      @user.destroy

      render json: { message: 'User deleted with success' }, status: :ok
    end

    private

    def find_user
      @user = User.find_by!(slug: params[:slug])
    rescue ActiveRecord::RecordNotFound
      render json: { errors: 'User not found' }, status: :not_found
    end

    def user_params
      params.permit(
        :name, :email, :password, :password_confirmation, :role
      )
    end
  end
end
