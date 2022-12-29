class Category < ActiveRecord::Base
  belongs_to :category_group, class_name: "CategoryGroup", foreign_key: "category_group_id"

  validates :name, presence: true

  delegate :category_type, to: :category_group

end