class ReportsController < ApplicationController

  def earnings
    earnings = @current_user.earnings
    filtered_earnings = filter_by_date_and_category(earnings)
    grouped_earnings = group_earnings(filtered_earnings)

    render json: { grouped_earnings: grouped_earnings }
  end

  def expenses
    expenses = @current_user.expenses
    filtered_expenses = filter_expenses(expenses)
    grouped_expenses = group_by_categories(filtered_expenses)

    render json: { grouped_expenses: grouped_expenses }
  end

  def payment_methods
    expenses = @current_user.expenses
    filtered_expenses = filter_expenses(expenses)
    grouped_expenses = group_by_payment_method(filtered_expenses)

    render json: { grouped_expenses: grouped_expenses }
  end

  private

  def filter_params
    params.permit(:start_date, :end_date, :payment_start_date, :payment_end_date, :category_id)
  end

  def filter_expenses(expenses)
    expenses = filter_by_date_and_category(expenses)
    expenses = expenses.by_payment_date_period(filter_params[:payment_start_date], filter_params[:payment_end_date])
    expenses
  end

  def filter_by_date_and_category(transactions)
    transactions = transactions.by_date_period(filter_params[:start_date], filter_params[:end_date])
    transactions = transactions.by_category_id(filter_params[:category_id])
    transactions
  end

  def group_earnings(earnings)
    earnings.sort_by(&:date).group_by(&:category_group).map do |group, earnings|
      [
        { title: group.title, color: group.color },
        earnings.group_by(&:category).map do |category, earnings|
          {
            name: category.name,
            earnings: earnings.map do |earning|
              {
                id: earning.id,
                name: earning.name,
                amount: earning.formatted_amount,
                date: earning.formatted_date,
                category_name: earning.category_name,
                category_group: earning.category_group_title
              }
            end
          }
        end
      ]
    end
  end

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

  def group_by_payment_method(expenses)
    expenses.sort_by(&:payment_date).group_by(&:payment_date).map do |date, expenses|
      [
        { payment_date: date.strftime("%d/%m/%Y") },
        expenses.group_by(&:payment_method).map do |method, expenses|
          {
            payment_method: method.name,
            total_amount: ("R$%.2f" % expenses.sum(&:amount)).gsub(".",","),
            expenses: map_expenses(expenses)
          }
        end
      ]
    end
  end

  def map_expenses(expenses)
    expenses.sort_by(&:date).map do |expense|
      {
        id: expense.id,
        name: expense.name,
        amount: expense.formatted_amount,
        installments_number: expense.installments_number,
        date: expense.formatted_date,
        payment_date: expense.formatted_payment_date,
        payment_method_name: expense.payment_method_name,
        category_name: expense.category_name,
        category_group: expense.category_group_title
      }
    end
  end

end
