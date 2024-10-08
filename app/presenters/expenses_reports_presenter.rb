class ExpensesReportsPresenter < BasePresenter
  def initialize(expenses:)
    @expenses = expenses
  end

  def group_by_categories
    {
      total_amount: number_to_currency_br(@expenses.sum(&:amount)),
      expenses: @expenses.sort_by(&:category_group_title).group_by(&:category_group).map do |group, expenses|
        {
          id: group.id,
          title: group.title,
          color: group.color,
          total_amount: number_to_currency_br(expenses.sum(&:amount)),
          total_amount_percentage: (expenses.sum(&:amount).to_f / @expenses.sum(&:amount) * 100).round(2),
          categories: expenses.sort_by(&:category_name).group_by(&:category).map do |category, expenses|
            {
              name: category.name,
              total_amount: number_to_currency_br(expenses.sum(&:amount)),
              total_amount_percentage: (expenses.sum(&:amount).to_f / @expenses.sum(&:amount) * 100).round(2),
              expenses: map_expenses(expenses)
            }
          end
        }
      end
    }
  end

  def group_by_payment_method
    {
      total_amount: number_to_currency_br(@expenses.sum(&:amount)),
      expenses: @expenses.sort_by(&:payment_date).group_by(&:payment_date).map do |date, expenses|
        {
          payment_date: format_date(date),
          total_amount: number_to_currency_br(expenses.sum(&:amount)),
          total_amount_percentage: (expenses.sum(&:amount).to_f / @expenses.sum(&:amount) * 100).round(2),
          payment_methods: expenses.group_by(&:payment_method).map do |method, expenses|
            {
              name: method.name,
              total_amount: number_to_currency_br(expenses.sum(&:amount)),
              total_amount_percentage: (expenses.sum(&:amount).to_f / @expenses.sum(&:amount) * 100).round(2),
              expenses: map_expenses(expenses)
            }
          end
        }
      end
    }
  end

  def map_expenses(expenses)
    expenses.sort_by(&:date).map do |expense|
      {
        id: expense.id,
        name: expense.name,
        amount: number_to_currency_br(expense.amount),
        # TO DO: change amount_value to amount
        # and amount to formatted_amount
        # [ cant change now because of old frontend ]
        amount_value: expense.amount,
        installments_number: expense.installments_number,
        is_installment: expense.installment?,
        date: format_date(expense.date),
        payment_date: format_date(expense.payment_date),
        payment_method_id: expense.payment_method_id,
        payment_method_name: expense.payment_method_name,
        category_id: expense.category_id,
        category_name: expense.category_name,
        category_group: expense.category_group_title,
        category_group_color: expense.category_group.color
      }
    end
  end

end