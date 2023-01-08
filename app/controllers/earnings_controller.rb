class EarningsController < ApplicationController

  def show
    earning = Earning.find(params[:id])

    render json: { earning: earning }
  rescue => e
    render json: { message: e.message }, status: :bad_request
  end

  def create
    validate_params!(earning_params)

    @earning = Earning.create!(earning_params)

    render json: { message: "Entrada criada com sucesso." }
  rescue => e
    render json: { message: e.message }, status: :bad_request
  end

  def update
    validate_params!(earning_params)

    earning = Earning.find(params[:id])
    earning.update!(earning_params)

    render json: { message: "Entrada atualizada com sucesso." }
  rescue => e
    render json: { message: e.message }, status: :bad_request
  end

  private

  def earning_params
    params.permit(earning: [
      :name, :amount, :category_id, :date
    ])[:earning].merge!(user_id: @current_user.id)
  end

  def validate_params!(params)
    request = Requests::EarningRequest.new(params: params)
    request.validate!
  end

end