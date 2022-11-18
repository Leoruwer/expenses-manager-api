class UsersController < ApplicationController
  def create
    user = CreateUser.new(user_params).execute

    if user&.errors.present?
      render json: { errors: user.errors.full_messages },
             status: :unprocessable_entity
    else
      render json: user, status: :created
    end
  end

  private

  def user_params
    params.permit(
      :name, :email, :password, :password_confirmation, :role
    )
  end
end
