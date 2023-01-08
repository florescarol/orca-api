class CategoriesController < ApplicationController

  def index
    validate_category_type!

    category_groups = @current_user.category_groups
    filtered_groups = category_groups.where(category_type: category_type).order(:title)
    grouped_categories = map_category_groups(filtered_groups)

    render json: { grouped_categories: grouped_categories }
  rescue => e
    render json: { message: e.message }, status: :bad_request
  end

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

  def category_type
    params.permit(:type)[:type]
  end

  def category_params
    params.permit(category: [
      :name, :category_group_id
    ])[:category]
  end

  def validate_category_type!
    raise InvalidCategoryTypeException.new unless CATEGORY_TYPES::ALL.include?(category_type)
  end

  def map_category_groups(groups)
    groups.map do |group|
      {
        id: group.id,
        title: group.title,
        color: group.color,
        category_type: group.category_type,
        categories: map_categories(group.categories)
      }
    end
  end

  def map_categories(categories)
    categories.order(:name).map { |category| { id: category.id, name: category.name }}
  end

end