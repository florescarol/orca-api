class Expense < ActiveRecord::Base
  belongs_to :user, class_name: "User"
  belongs_to :category, class_name: "Category"
  belongs_to :payment_method, class_name: "PaymentMethod"

  delegate :category_group, to: :category

  validates :name, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 1 }

  def paid_in_installments?
    self.installments_number > 1
  end

end