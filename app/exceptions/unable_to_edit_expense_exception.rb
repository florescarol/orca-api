class UnableToEditExpenseException < StandardError
  def initialize(message)
    super(message)
  end
end
