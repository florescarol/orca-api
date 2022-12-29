class PaymentMethod < ActiveRecord::Base
  belongs_to :user, class_name: "User", foreign_key: "user_id"

  validates :name, presence: true

end
