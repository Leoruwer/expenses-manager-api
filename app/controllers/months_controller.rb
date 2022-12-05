# frozen_string_literal: true

class MonthsController < ApplicationController
  before_action :authorize_request
  before_action :find_user, except: %i[show destroy]
  before_action :find_month, except: %i[index create]

  def index
    months = Month.where(user_id: @user.id).all

    render json: months, status: :ok
  end

  def show
    render json: @month, status: :ok
  end

  def create
    new_month = Month.new(month_params)

    if new_month.save
      render json: { message: 'Month created with success' }, status: :created
    else
      render json: { errors: new_month.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update
    if @month.update(month_params)
      render json: { message: 'Month updated with success' }, status: :ok
    else
      render json: { errors: @month.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def destroy
    @month.destroy

    render json: { message: 'Month deleted with success' }, status: :ok
  end

  private

  def find_user
    @user = User.find(params[:user_id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'User not found' }, status: :not_found
  end

  def find_month
    @month = Month.find_by!(slug: params[:slug])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'Month not found' }, status: :not_found
  end

  def month_params
    params.permit(
      :name, :user_id
    )
  end
end
