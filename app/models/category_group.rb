class CategoryGroup < ActiveRecord::Base
  belongs_to :user, class_name: "User", foreign_key: "user_id"

  validates :title, presence: true
  validates :category_type, inclusion: { in: CATEGORY_TYPES::ALL }

end
