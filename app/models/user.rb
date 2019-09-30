# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  allow_password_change  :boolean          default(FALSE), not null
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  full_name              :string           not null
#  gender                 :integer          default("other"), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  provider               :string           default("email"), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  tokens                 :json
#  uid                    :string           default(""), not null
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  player_id              :string
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#
class User < ApplicationRecord
  include DeviseTokenAuth::Concerns::User
  include ActiveStorageSupport::SupportForBase64

  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :validatable, :confirmable, :trackable

  enum gender: { male: 0, female: 1, other: 2 }

  has_many :targets, dependent: :destroy
  has_many :conversation_users, dependent: :destroy
  has_many :conversations, through: :conversation_users
  has_many :messages, dependent: :destroy
  has_many :contacts, dependent: :destroy
  has_one_base64_attached :avatar

  before_validation :init_uid
  before_save :add_default_avatar, on: %i[create]

  validates :email, presence: true, uniqueness: {
    scope: :provider, case_sensitive: false
  }
  validates :full_name, :gender, presence: true
  validates :gender, inclusion: { in: genders }

  private

  def init_uid
    self.uid = email if uid.blank? && provider == 'email'
  end

  def add_default_avatar
    return if avatar.attached?

    avatar.attach(
      io: File.open(Rails.root.join('public', 'images', 'no_image_av.png')),
      filename: 'no_image_av.png', content_type: 'image/png'
    )
  end
end
