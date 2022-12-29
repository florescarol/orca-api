class SettingsController < ApplicationController

  def index
    render json: { payment_methods: payment_methods, grouped_categories: grouped_categories }
  rescue => e
    render json: { message: e.message }, status: :bad_request
  end

  private

  def payment_methods
    @current_user.payment_methods.map { |method| { id: method.id, name: method.name }}
  end

  def grouped_categories
    @current_user.category_groups.map do |group|
      {
        id: group.id,
        title: group.title,
        color: group.title,
        categories: map_categories(group.categories)
      }
    end
  end

  def map_categories(categories)
    categories.map { |category| { id: category.id, name: category.name }}
  end

end