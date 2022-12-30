class ExpensesController < ApplicationController

  def show
    expense = Expense.find(params[:id])

    render json: { expense: expense }
  rescue => e
    render json: { message: e.message }, status: :bad_request
  end

  def create
    validate_params!(expense_params)

    @expense = Expense.create!(expense_params)
    create_installments if @expense.paid_in_installments?

    render json: { message: "Despesa criada com sucesso." }
  rescue => e
    render json: { message: e.message }, status: :bad_request
  end

  private

  def expense_params
    params.permit(expense: [
      :name, :amount, :installments_number,
      :category_id, :payment_date, :date,
      :payment_method_id
    ])[:expense].merge!(user_id: @current_user.id)
  end

  def validate_params!(params)
    request = Requests::ExpenseRequest.new(params: params)
    request.validate!
  end

  def create_installments
    use_case = ::CreateExpenseInstallments.build
    use_case.execute(expense_id: @expense.id)
  end

end
