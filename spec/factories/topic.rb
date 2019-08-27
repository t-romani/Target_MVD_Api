FactoryBot.define do
  factory :topic do
    title     { Faker::Verb.base }
    image     {
      fixture_file_upload(Rails.root
        .join('spec', 'support', 'images', 'rootstrap.png'), 'image/png')
    }
  end
end
