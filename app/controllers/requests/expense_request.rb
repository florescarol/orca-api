module Requests
  class ExpenseRequest

    def initialize(params:)
      @params = params
    end

    def validate!
      validate_required_keys!
      validate_date_params!
      validate_numbers!
    end

    private

    def required_keys
      [
        "name", "amount", "installments_number",
        "date", "payment_date", "category_id",
        "user_id", "payment_method_id"
      ]
    end

    def validate_required_keys!
      required_keys.each do |key|
        raise_empty_param_exception(key) unless @params.keys.include?(key) && @params[key].present?
      end
    end

    def validate_date_params!
      dates = [
        @params[:date],
        @params[:payment_date]
      ]

      dates.each { |date| validate_date_format!(date) }
    end

    def validate_date_format!(date)
      date.to_date
    rescue => e
      raise_invalid_date_exception(date)
    end

    def validate_numbers!
      numbers = [
        @params[:amount],
        @params[:installments_number]
      ]

      numbers.each do |number|
        raise_invalid_amount(number) unless number.to_f > 0.0
      end
    end

    def raise_empty_param_exception(key)
      raise ::MissingParamException.new(param: key)
    end

    def raise_invalid_date_exception(date)
      raise ::InvalidDateException.new(date: date)
    end

    def raise_invalid_amount(amount)
      raise ::InvalidAmountException.new(amount: amount)
    end
  end
end