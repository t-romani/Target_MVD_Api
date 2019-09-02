# == Schema Information
#
# Table name: targets
#
#  id         :bigint           not null, primary key
#  latitude   :float            not null
#  longitude  :float            not null
#  radius     :float            not null
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  topic_id   :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_targets_on_topic_id                        (topic_id)
#  index_targets_on_topic_id_and_title_and_user_id  (topic_id,title,user_id) UNIQUE
#  index_targets_on_user_id                         (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (topic_id => topics.id)
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :target do
    title     { Faker::Verb.base }
    latitude  { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    radius    { Faker::Number.between(from: 50, to: 1000) }
    topic
    user
  end
end
