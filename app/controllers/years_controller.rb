# frozen_string_literal: true

class YearsController < ApplicationController
  before_action :authorize_request
  before_action :find_user, except: %i[show destroy]
  before_action :find_year, except: %i[index create]

  def index
    years = Year.where(user_id: @user.id).all

    render json: years, status: :ok
  end

  def show
    render json: @year, status: :ok
  end

  def create
    new_year = Year.new(year_params)

    if new_year.save
      render json: { message: 'Year created with success' }, status: :created
    else
      render json: { errors: new_year.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update
    if @year.update(year_params)
      render json: { message: 'Year updated with success' }, status: :ok
    else
      render json: { errors: @year.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def destroy
    @year.destroy

    render json: { message: 'Year deleted with success' }, status: :ok
  end

  private

  def find_user
    @user = User.find(params[:user_id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'User not found' }, status: :not_found
  end

  def find_year
    @year = Year.find_by!(slug: params[:slug])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'Year not found' }, status: :not_found
  end

  def year_params
    params.permit(
      :name, :user_id
    )
  end
end
