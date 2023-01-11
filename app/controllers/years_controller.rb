# frozen_string_literal: true

class YearsController < ApplicationController
  before_action :authorize_user

  def index
    render json: current_user.years, status: :ok
  end

  def show
    return render_year_not_found if year.blank?

    render json: year, status: :ok
  end

  def create
    new_year = current_user.years.new(year_params)

    if new_year.save
      render json: { message: 'Year created with success' }, status: :created
    else
      render json: { errors: new_year.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update
    return render_year_not_found if year.blank?

    if year.update(year_params)
      render json: { message: 'Year updated with success' }, status: :ok
    else
      render json: { errors: @year.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def destroy
    return render_year_not_found if year.blank?

    year.destroy

    render json: { message: 'Year deleted with success' }, status: :ok
  end

  private

  def year
    @year ||= current_user.years.find_by(slug: params[:slug])
  end

  def render_year_not_found
    render json: { errors: 'Year not found' }, status: :not_found
  end

  def year_params
    params.permit(
      :name, :user_id
    )
  end
end
