class User < ApplicationRecord
  has_secure_password
  has_many :category_groups, class_name: "CategoryGroup", foreign_key: "user_id"
  has_many :payment_methods, class_name: "PaymentMethod", foreign_key: "user_id"
  has_many :expenses, class_name: "Expense"
  has_many :earnings, class_name: "Earning"

  validates :name, presence: true
  validates :username, presence: true, uniqueness: true, length: { maximum: 20 }
  validates :password, presence: true, length: { minimum: 6 }

  before_create -> { self.username = self.username.strip.downcase }

  def generate_remember_token!(password:)
    token = Digest::SHA1.hexdigest(SecureRandom.urlsafe_base64)
    self.update!(remember_token: token, password: password)
    token
  end

end
