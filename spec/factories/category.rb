FactoryBot.define do
  factory :category, class: "Category" do
    association :category_group

    name { "Course" }
  end
end