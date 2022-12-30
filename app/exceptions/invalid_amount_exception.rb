class InvalidAmountException < StandardError
  def initialize(amount:)
    super("O valor '#{amount}' é inválido.")
  end
end
