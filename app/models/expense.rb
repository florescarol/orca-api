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

  def payment_method_name
    self.payment_method.name
  end

  def category_name
    self.category.name
  end

  def formatted_amount
    "R$%.2f" % self.amount
  end

  def formatted_date
    self.date.strftime("%d/%m/%Y")
  end

  def formatted_payment_date
    self.payment_date.strftime("%d/%m/%Y")
  end

  def installments
    Expense.where(first_installment_id: self.id)
  end

end