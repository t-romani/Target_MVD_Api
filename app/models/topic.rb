# == Schema Information
#
# Table name: topics
#
#  id         :bigint           not null, primary key
#  title      :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_topics_on_title  (title) UNIQUE
#

class Topic < ApplicationRecord
  include ActiveStorageSupport::SupportForBase64

  has_one_base64_attached :image

  validates :title, presence: true, uniqueness: true
  validate :image_presence

  def image_presence
    errors.add(:attached_image, 'no image added') unless image.attached?
  end

  # include ActiveStorageValidations::AttachedValidator
  # validates :image, attached: true
end
