module Requests
  class EarningRequest

    def initialize(params:)
      @params = params
    end

    def validate!
      validate_required_keys!
      validate_date!
      validate_amount!
    end

    private

    def required_keys
      [
        "name", "amount", "date", "category_id", "user_id"
      ]
    end

    def validate_required_keys!
      required_keys.each do |key|
        raise_empty_param_exception(key) unless @params.keys.include?(key) && @params[key].present?
      end
    end

    def validate_date!
      date = @params[:date]
      date.to_date
    rescue => e
      raise_invalid_date_exception(date)
    end

    def validate_amount!
      amount = @params[:amount]
      raise_invalid_amount(amount) unless amount.to_f > 0.0
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