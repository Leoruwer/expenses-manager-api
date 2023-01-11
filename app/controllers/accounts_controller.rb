# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :authorize_user

  def index
    render json: current_user.accounts, status: :ok
  end

  def show
    return render_account_not_found if account.blank?

    render json: account, status: :ok
  end

  def create
    new_account = current_user.accounts.new(account_params)

    if new_account.save
      render json: { message: 'Account created with success' }, status: :created
    else
      render json: { errors: new_account.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update
    return render_account_not_found if account.blank?

    if account.update(account_params)
      render json: { message: 'Account updated with success' }, status: :ok
    else
      render json: { errors: @account.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def destroy
    return render_account_not_found if account.blank?

    account.destroy

    render json: { message: 'Account deleted with success' }, status: :ok
  end

  private

  def account
    @account ||= current_user.accounts.find_by(slug: params[:slug])
  end

  def render_account_not_found
    render json: { errors: 'Account not found' }, status: :not_found
  end

  def account_params
    params.permit(
      :name
    )
  end
end
