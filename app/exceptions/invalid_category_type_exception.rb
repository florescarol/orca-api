class InvalidCategoryTypeException < StandardError
  def initialize
    super("Tipo de categoria inválida.")
  end
end
