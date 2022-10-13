class Api::V1::UsersController < ApplicationController
  before_action :authorize_request, except: :create
  before_action :find_user, except: %i[create index]

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
    render json: {message: 'User found with success', data: @user}
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

    if user.admin?
      render json: {message: 'Cannot delete user admin'}, status: :bad_request
    else
      ActiveRecord::Base.transaction do
        user.destroy
      end

      render json: {message: 'User deleted with success'}, status: :ok
    end
  end

  private

  def user_params
    params.require(:users).permit(:name, :email, :password, :password_confirmation, :type)
  end

  def find_user
    @user = User.find_by_username!(params[:_username])
    rescue ActiveRecord::RecordNotFound
      render json: { errors: 'User not found' }, status: :not_found
  end
end
