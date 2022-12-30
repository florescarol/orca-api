class UpdateExpenseWithInstallments

  def self.build
    new(
      expense_model: Expense,
    )
  end

  def initialize(expense_model:)
    @expense_model = expense_model
  end

  def execute(expense_id:, params:)
    @expense = @expense_model.find(expense_id)
    installments_number_difference = params[:installments_number].to_i - @expense.installments_number

    @expense.update!(params)
    @installments = @expense.installments.sort_by(&:payment_date)

    if installments_number_difference > 0
      add_installments(installments_number_difference)
    elsif installments_number_difference < 0
      delete_installments(installments_number_difference)
    end

    update_installments!
  end

  private

  def update_installments!
    installments = @expense.installments
    installments.each_with_index do |installment, number|
      number += 1
      payment_date = @expense.payment_date + number.month

      installment.update!(
        name: @expense.name,
        amount: @expense.amount,
        date: @expense.date,
        installments_number: @expense.installments_number,
        category_id: @expense.category_id,
        payment_method_id: @expense.payment_method_id,
        payment_date: payment_date
      )
    end
  end

  def delete_installments(quantity)
    installments = @installments.last(quantity.abs)
    installments.each { |installment| installment.destroy! }
  end

  def add_installments(quantity)
    last_installment = @installments.last || @expense

    for number in 1..quantity do
      payment_date = last_installment.payment_date + number.month
      installment = last_installment.dup

      installment.update!(
        payment_date: payment_date,
        first_installment_id: @expense.id
      )
    end
  end

end
