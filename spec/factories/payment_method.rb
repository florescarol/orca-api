FactoryBot.define do
  factory :payment_method, class: "PaymentMethod" do
    association :user

    name { "Credit card" }
  end
end
