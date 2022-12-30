class InvalidDateException < StandardError
  def initialize(date:)
    super("A data '#{date}' é inválida.")
  end
end
