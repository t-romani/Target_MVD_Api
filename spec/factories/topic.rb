FactoryBot.define do
  factory :topic do
    title { Faker::Verb.base }
  end
end
