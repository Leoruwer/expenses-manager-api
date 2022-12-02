# frozen_string_literal: true

class CategoriesController < ApplicationController
  before_action :authorize_request
  before_action :find_user, except: %i[show destroy]
  before_action :find_category, except: %i[index create]

  def index
    categories = Category.where(user_id: @user.id).all

    render json: categories, status: :ok
  end

  def show
    render json: @category, status: :ok
  end

  def create
    new_category = Category.new(category_params)

    if new_category.save
      render json: { message: 'Category created with success' }, status: :created
    else
      render json: { errors: new_category.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      render json: { message: 'Category updated with success' }, status: :ok
    else
      render json: { errors: @category.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy

    render json: { message: 'Category deleted with success' }, status: :ok
  end

  private

  def find_user
    @user = User.find(params[:user_id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'User not found' }, status: :not_found
  end

  def find_category
    @category = Category.find_by!(slug: params[:slug])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'Category not found' }, status: :not_found
  end

  def category_params
    params.permit(
      :name, :user_id
    )
  end
end
