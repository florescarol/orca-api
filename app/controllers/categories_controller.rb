class CategoriesController < ApplicationController

  def show
    category = Category.find(params[:id])

    render json: { category: category }
  rescue => e
    render json: { message: e.message }, status: :bad_request
  end

  def create
    @category = Category.create!(category_params)

    render json: { message: "Categoria criada com sucesso." }
  rescue => e
    render json: { message: e.message }, status: :bad_request
  end

  def update
    category = Category.find(params[:id])
    category.update!(category_params)

    render json: { message:  "Categoria atualizada com sucesso." }
  rescue => e
    render json: { message: e.message }, status: :bad_request
  end

  private

  def category_params
    params.permit(category: [
      :name, :category_group_id
    ])[:category]
  end

  def set_category_groups
    @category_groups = @current_user.category_groups.map {|cat| [cat.title, cat.id]}
  end

end