class Expense < ActiveRecord::Base
  belongs_to :user, class_name: "User"
  belongs_to :category, class_name: "Category"
  belongs_to :payment_method, class_name: "PaymentMethod"

  delegate :category_group, to: :category

  validates :name, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 1 }

  scope :by_date_period, -> (start_date, end_date) {
    period = start_date&.to_date..end_date&.to_date
    where(date: period)
  }

  scope :by_payment_date_period, -> (start_date, end_date) {
    period = start_date&.to_date..end_date&.to_date
    where(payment_date: period)
  }

  scope :by_category_id, ->(id){
    return if id.nil?
    where(category_id: id)
  }

  def paid_in_installments?
    self.installments_number > 1
  end

  def installment?
    self.first_installment_id.present?
  end

  def payment_method_name
    self.payment_method.name
  end

  def category_group_title
    self.category_group.title
  end

  def category_name
    self.category.name
  end

  def installments
    Expense.where(first_installment_id: self.id)
  end

end