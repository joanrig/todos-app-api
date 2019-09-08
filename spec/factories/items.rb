FactoryBot.define do
  factory :item do
    name { Faker::Name }
    done { false }
    todo { nil }
  end
end
