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

class Target < ApplicationRecord
  belongs_to :topic
  belongs_to :user

  validates :latitude, :longitude, :radius, presence: true
  validates :title, presence: true, uniqueness: {
    scope: %i[topic_id user_id], case_sensitive: false
  }

  validate :limit_number_of_targets

  after_create :check_matching_targets

  reverse_geocoded_by :latitude, :longitude

  scope :match_not_user_topic, lambda { |params|
    where(topic_id: params[0]).where.not(user_id: params[1])
  }

  private

  def limit_number_of_targets
    return if user && user.targets.count < 10

    errors.add(:base,
               I18n.t('api.error.invalid_request.max_target_limit'))
  end

  def check_matching_targets
    matching_users = []
    Target.match_not_user_topic([topic.id, user.id])
          .map do |target|
      matching_users.push(target.user) if
      matches?(matching_users, target)
    end

    return if matching_users.empty?

    matching_users.push(user)
    notificate_users(matching_users)
    create_conversations(matching_users)
  end

  def notificate_users(matching_users)
    NotifyRequestJob.perform_later(nil, matching_users, nil)
  end

  def matches?(matching_users, target)
    matching_users.exclude?(target.user) &&
      distance_to(target) <= radius + target.radius
  end

  def create_conversations(matching_users)
    Conversation.create_conversations(matching_users)
  end
end
