class Earning < ApplicationRecord
  belongs_to :user, class_name: "User"
  belongs_to :category, class_name: "Category"

  delegate :category_group, to: :category

  validates :name, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 1 }

  scope :by_date_period, -> (start_date, end_date) {
    period = start_date&.to_date..end_date&.to_date
    where(date: period)
  }

  scope :by_category_id, ->(id){
    return if id.nil?
    where(category_id: id)
  }

  def category_name
    self.category.name
  end

  def formatted_date
    self.date.strftime("%d/%m/%Y")
  end

end