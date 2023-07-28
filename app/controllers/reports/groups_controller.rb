# frozen_string_literal: true

module Reports
  class GroupsController < ApplicationController
    before_action :authorize_user

    def show
      render json: expenses, each_serializer: ::ExpenseSerializer, status: :ok
    end

    private

    def expenses
      @expenses = current_user.expenses.by_due(params[:year], params[:month])
    end
  end
end
