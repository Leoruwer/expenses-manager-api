# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :authorize_request
  before_action :find_user, except: %i[show destroy]
  before_action :find_account, except: %i[index create]

  def index
    accounts = Account.where(user_id: @user.id).all

    render json: accounts, status: :ok
  end

  def show
    render json: @account, status: :ok
  end

  def create
    new_account = Account.new(account_params)

    if new_account.save
      render json: { message: 'Account created with success' }, status: :created
    else
      render json: { errors: new_account.errors.full_messages },
              status: :unprocessable_entity
    end
  end

  def update
    if @account.update(account_params)
      render json: { message: 'Account updated with success' }, status: :ok
    else
      render json: { errors: @account.errors.full_messages },
              status: :unprocessable_entity
    end
  end

  def destroy
    @account.destroy

    render json: { message: 'Account deleted with success' }, status: :ok
  end

  private

  def find_user
    @user = User.find(params[:user_id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'User not found' }, status: :not_found
  end

  def find_account
    @account = Account.find_by!(slug: params[:slug])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'Account not found' }, status: :not_found
  end

  def account_params
    params.permit(
      :name, :user_id
    )
  end
end
