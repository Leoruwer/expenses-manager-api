# frozen_string_literal: true

class MonthsController < ApplicationController
  before_action :authorize_user

  def index
    render json: current_user.months, status: :ok
  end

  def show
    return render_month_not_found if month.blank?

    render json: month, status: :ok
  end

  def create
    new_month = current_user.months.new(month_params)

    if new_month.save
      render json: { message: 'Month created with success' }, status: :created
    else
      render json: { errors: new_month.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update
    return render_month_not_found if month.blank?

    if month.update(month_params)
      render json: { message: 'Month updated with success' }, status: :ok
    else
      render json: { errors: @month.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def destroy
    return render_month_not_found if month.blank?

    month.destroy

    render json: { message: 'Month deleted with success' }, status: :ok
  end

  private

  def month
    @month ||= current_user.months.find_by(slug: params[:slug])
  end

  def render_month_not_found
    render json: { errors: 'Month not found' }, status: :not_found
  end

  def month_params
    params.permit(
      :name
    )
  end
end
