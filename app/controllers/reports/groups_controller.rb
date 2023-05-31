# frozen_string_literal: true

module Reports
  class GroupsController < ApplicationController
    before_action :authorize_user

    def show
      render json: body, status: :ok
    end

    private

    def expenses
      @expenses = current_user.expenses.by_due(params[:year], params[:month])
    end

    def body
      {
        params[:year] => {
          params[:month] => {
            expenses: expenses
          }
        }
      }.to_json
    end
  end
end
