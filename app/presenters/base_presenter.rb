class BasePresenter
  include ActionView::Helpers::NumberHelper

  def number_to_currency_br(number)
    number_to_currency(number, :unit => "R$ ", :separator => ",", :delimiter => ".")
  end

  def format_date(date)
    date.strftime("%d/%m/%Y")
  end

end