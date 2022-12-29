class PaymentMethodsController < ApplicationController

  def show
    payment_method = PaymentMethod.find(params[:id])

    render json: { payment_method: payment_method }
  rescue => e
    render json: { message: e.message }, status: :bad_request
  end

  def create
    payment_method = PaymentMethod.create!(payment_method_params)

    render json: { message: "Método de pagamento criada com sucesso." }
  rescue => e
    render json: { message: e.message }, status: :bad_request
  end

  def update
    payment_method = PaymentMethod.find(params[:id])
    payment_method.update!(payment_method_params)

    render json: { message: "Método de pagamento atualizada com sucesso." }
  rescue => e
    render json: { message: e.message }, status: :bad_request
  end

  private

  def payment_method_params
    params.permit(payment_method: [
      :name
    ])[:payment_method]
    .merge!(user_id: @current_user.id)
  end

end