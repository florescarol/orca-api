class UserNotFoundException < StandardError
  def initialize(username:)
    super("O usuário '#{username}' não foi encontrado.")
  end
end
