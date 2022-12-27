FactoryBot.define do
  factory :user, class: "User" do
    name { Faker::Name.name }
    username { Faker::Internet.unique.username(specifier: 10) }
    password { Faker::Internet.password(min_length: 6) }
    token { Faker::Internet.device_token }
  end
end
