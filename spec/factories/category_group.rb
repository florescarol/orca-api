FactoryBot.define do
  factory :category_group, class: "CategoryGroup" do
    association :user

    title { "Alimentação" }
    category_type { "expense" }

    trait :earning do
      category_type { "earning" }
    end
  end
end