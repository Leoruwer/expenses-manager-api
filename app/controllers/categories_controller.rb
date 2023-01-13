# frozen_string_literal: true

class CategoriesController < ApplicationController
  before_action :authorize_user

  def index
    render json: current_user.categories, status: :ok
  end

  def show
    return render_category_not_found if category.blank?

    render json: category, status: :ok
  end

  def create
    new_category = current_user.categories.new(category_params)

    if new_category.save
      render json: { message: 'Category created with success' }, status: :created
    else
      render json: { errors: new_category.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update
    return render_category_not_found if category.blank?

    if category.update(category_params)
      render json: { message: 'Category updated with success' }, status: :ok
    else
      render json: { errors: category.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def destroy
    return render_category_not_found if category.blank?

    category.destroy

    render json: { message: 'Category deleted with success' }, status: :ok
  end

  private

  def category
    @category ||= current_user.categories.find_by(slug: params[:slug])
  end

  def render_category_not_found
    render json: { errors: 'Category not found' }, status: :not_found
  end

  def category_params
    params.permit(:name)
  end
end
