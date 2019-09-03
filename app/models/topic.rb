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

  validates :title, presence: true, uniqueness: { case_sensitive: false }

  before_save :add_default_image, on: %i[create]

  def add_default_image
    return if image.attached?

    image.attach(
      io: File.open(Rails.root.join('public', 'images', 'no_image_av.png')),
      filename: 'no_image_av.png', content_type: 'image/png'
    )
  end
end
