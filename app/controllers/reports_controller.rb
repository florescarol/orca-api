class ReportsController < ApplicationController

  def earnings
    earnings = @current_user.earnings
    filtered_earnings = filter_by_date_and_category(earnings)
    presenter = ::EarningsReportsPresenter.new(earnings: filtered_earnings)

    render json: { grouped_earnings: presenter.group_by_categories }
  end

  def expenses
    expenses = @current_user.expenses
    filtered_expenses = filter_expenses(expenses)
    presenter = ::ExpensesReportsPresenter.new(expenses: filtered_expenses)

    render json: { grouped_expenses: presenter.group_by_categories }
  end

  def payment_methods
    expenses = @current_user.expenses
    filtered_expenses = filter_expenses(expenses)
    presenter = ::ExpensesReportsPresenter.new(expenses: filtered_expenses)

    render json: { grouped_expenses: presenter.group_by_payment_method }
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

end
