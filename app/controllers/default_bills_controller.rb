# frozen_string_literal: true

class DefaultBillsController < ApplicationController
  before_action :authorize_request

  def index
    render json: current_user.default_bills, status: :ok
  end

  def show
    return render_default_bill_not_found if default_bill.blank?

    render json: default_bill, status: :ok
  end

  def create
    new_default_bill = current_user.default_bills.new(default_bill_params)

    if new_default_bill.save
      render json: { message: 'Default Bill created with success' }, status: :created
    else
      render json: { errors: new_default_bill.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update
    return render_default_bill_not_found if default_bill.blank?

    if default_bill.update(default_bill_params)
      render json: { message: 'Default Bill updated with success' }, status: :ok
    else
      render json: { errors: default_bill.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def destroy
    return render_default_bill_not_found if default_bill.blank?

    default_bill.destroy

    render json: { message: 'Default Bill deleted with success' }, status: :ok
  end

  private

  def default_bill
    @default_bill ||= current_user.default_bills.find_by(slug: params[:slug])
  end

  def render_default_bill_not_found
    render json: { errors: 'Default Bill not found' }, status: :not_found
  end

  def default_bill_params
    params.permit(:name, :value)
  end
end
