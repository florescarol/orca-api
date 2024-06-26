class Earning < ApplicationRecord
  belongs_to :user, class_name: "User"
  belongs_to :category, class_name: "Category"

  has_one :category_group, through: :category

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

  scope :by_category_group_id, ->(id){
    return if id.nil?
    includes(:category_group).where(category_group: { id: id })
  }

  def category_name
    self.category.name
  end

  def category_group_title
    self.category_group.title
  end

end