# frozen_string_literal: true

class ExpensesController < ApplicationController
  before_action :authorize_user

  def index
    render json: current_user.expenses, status: :ok
  end

  def show
    return render_not_found('Expense not found') if expense.blank?

    render json: expense, status: :ok
  end

  def create
    return render_not_found('Account must exist') if current_user.accounts.where(id: params[:account_id]).blank?
    return render_not_found('Category must exist') if current_user.categories.where(id: params[:category_id]).blank?

    new_expense = current_user.expenses.new(expense_params)

    if new_expense.save
      render json: { message: 'Expense created with success' }, status: :created
    else
      render json: { errors: new_expense.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update
    return render_not_found('Expense not found') if expense.blank?
    return render_not_found('Account must exist') if current_user.accounts.where(id: params[:account_id]).blank?
    return render_not_found('Category must exist') if current_user.categories.where(id: params[:category_id]).blank?

    if expense.update(expense_params)
      render json: { message: 'Expense updated with success' }, status: :ok
    else
      render json: { errors: expense.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def destroy
    return render_not_found('Expense not found') if expense.blank?

    expense.destroy

    render json: { message: 'Expense deleted with success' }, status: :ok
  end

  private

  def expense
    @expense ||= current_user.expenses.find_by(slug: params[:slug])
  end

  def expense_params
    params.permit(:name, :value_in_cents, :due_at, :paid_at, :account_id, :category_id)
  end
end
