FactoryBot.define do
  factory :earning, class: "Earning" do
    association :category
    association :user

    name { "Salary" }
    amount { 200 }
    date { "2022-07-30" }
  end
end