FactoryBot.define do
  factory :category_group, class: "CategoryGroup" do
    association :user

    title { "Alimentação" }
    category_type { "expense" }
  end
end