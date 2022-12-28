class WrongPasswordException < StandardError
  def initialize
    super("Senha inválida. Tente novamente.")
  end
end
