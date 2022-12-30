class ReportsController < ApplicationController
  def expenses
    expenses = @current_user.expenses
    grouped_expenses = group_by_categories(expenses)

    render json: { grouped_expenses: grouped_expenses }
  end

  private

  def group_by_categories(transactions)
    transactions.sort_by(&:date).group_by(&:category_group).map do |group, expenses|
      [
        { title: group.title, color: group.color },
        expenses.group_by(&:category).map do |category, expenses|
          {
            name: category.name,
            expenses: map_expenses(expenses)
          }
        end
      ]
    end
  end

  def map_expenses(expenses)
    expenses.map do |expense|
      {
        id: expense.id,
        name: expense.name,
        amount: expense.formatted_amount,
        installments_number: expense.installments_number,
        date: expense.formatted_date,
        payment_date: expense.formatted_payment_date,
        payment_method_name: expense.payment_method_name
      }
    end
  end

end
