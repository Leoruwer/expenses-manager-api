class Api::V1::UsersController < ApplicationController
  def index
    users = User.all

    render json: {message: 'All users found with success', data: users}, status: :ok
  end

  def create
    user = User.new(user_params)

    if user.valid?
      ActiveRecord::Base.transaction do
        user.save!
      end

      render json: {message: 'User created with success'}, status: :ok
    else
      render json: {message: 'Error when creating new user', errors: user.errors.full_messages}, status: :bad_request
    end
  end

  def show
    user = User.find(params[:id])

    render json: {message: 'User found with success', data: user}
  end

  def update
    user = User.find(params[:id])

    if user.valid?
      ActiveRecord::Base.transaction do
        user.update(user_params)
      end

      render json: {message: 'User updated with success'}, status: :ok
    else
      render json: {message: 'Error when updating new user', errors: user.errors.full_messages}, status: :bad_request
    end
  end

  def destroy
    user = User.find(params[:id])

    ActiveRecord::Base.transaction do
      user.destroy
    end

    render json: {message: 'User deleted with success'}, status: :ok
  end

  private

  def user_params
    params.require(:users).permit(:name, :email, :password, :type)
  end
end
