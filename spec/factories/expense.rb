FactoryBot.define do
  factory :expense, class: "Expense" do
    association :category
    association :user
    association :payment_method

    name { "Matrícula" }
    amount { 1000 }
    date { "2022-07-30" }
    payment_date { "2022-07-30" }
  end
end