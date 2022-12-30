class CreateExpenseInstallments

  def self.build
    new(
      expense_model: Expense,
    )
  end

  def initialize(expense_model:)
    @expense_model = expense_model
  end

  def execute(expense_id:)
    expense = @expense_model.find(expense_id)

    installments_number = expense.installments_number
    first_installment_id = expense.id

    for number in 1...installments_number do
      payment_date = expense.payment_date + number.month
      installment = expense.dup

      installment.update!(
        first_installment_id: first_installment_id,
        payment_date: payment_date
      )
    end
  end

end
