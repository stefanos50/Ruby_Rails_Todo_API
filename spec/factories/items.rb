FactoryBot.define do
  factory :item do
    description { Faker::Lorem.character }
    done { false }
    todo
  end
end