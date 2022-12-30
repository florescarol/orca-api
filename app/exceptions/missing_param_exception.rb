class MissingParamException < StandardError
  def initialize(param:)
    super("O parâmetro #{param} é obrigatório.")
  end
end
