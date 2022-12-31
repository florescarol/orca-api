class CategoryGroupsController < ApplicationController

  def types
    category_types = [
      { text: "Entrada", value: CATEGORY_TYPES::EARNING },
      { text: "Despesa", value: CATEGORY_TYPES::EXPENSE }
    ]
    render json: { types: category_types }
  end

  def index
    render json: { category_groups: @current_user.category_groups.order(:title) }
  end

  def show
    category_group = CategoryGroup.find(params[:id])

    render json: { category_group: category_group }
  rescue => e
    render json: { message: e.message }, status: :bad_request
  end

  def create
    @category_group = CategoryGroup.create!(category_group_params)

    render json: { message: "Grupo de categoria criado com sucesso." }
  rescue => e
    render json: { message: e.message }, status: :bad_request
  end

  def update
    category_group = CategoryGroup.find(params[:id])
    category_group.update!(category_group_params)

    render json: { message: "Grupo de categoria atualizado com sucesso." }
  rescue => e
    render json: { message: e.message }, status: :bad_request
  end

  private

  def category_group_params
    params.permit(category_group: [
      :title, :category_type
    ])[:category_group]
    .merge!(user_id: @current_user.id)
    .merge!(color: color)
  end

  def color
    color = params[:category_group][:color]

    return "" if color == "#000000"
    color
  end

end
