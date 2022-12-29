class CategoryGroup < ActiveRecord::Base
  belongs_to :user, class_name: "User", foreign_key: "user_id"
  has_many :categories, class_name: "Category"

  validates :title, presence: true
  validates :category_type, inclusion: { in: CATEGORY_TYPES::ALL }

end
