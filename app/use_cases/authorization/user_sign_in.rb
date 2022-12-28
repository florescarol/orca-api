module Authorization
  class UserSignIn
    def self.build
      new(
        user_model: User
      )
    end

    def initialize(user_model:)
      @user_model = user_model
    end

    def execute(username:, password:)
      user = @user_model.find_by(username: username)

      raise_user_not_found(username) if user.nil?
      raise_wrong_password unless user.authenticate(password)

      user.generate_remember_token!(password: password)
      user
    end

    private

    def raise_user_not_found(username)
      raise UserNotFoundException.new(username: username)
    end

    def raise_wrong_password
      raise WrongPasswordException.new
    end

  end
end