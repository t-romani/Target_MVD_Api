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
#  topic_id   :bigint           not null
#  user_id    :bigint           not null
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

class Target < ApplicationRecord
  belongs_to :topic
  belongs_to :user

  validates :latitude, :longitude, :radius, presence: true
  validates :title, presence: true, uniqueness: {
    scope: %i[topic_id user_id], case_sensitive: false
  }

  validate :limit_number_of_targets

  private

  def limit_number_of_targets
    return if user && user.targets.count < 10

    errors.add(:base, I18n
      .t('api.error.invalid_request.max_target_limit'))
  end
end
