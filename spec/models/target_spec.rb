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

require 'rails_helper'

describe Target, type: :model do
  let!(:user)          { create(:user) }

  subject { build(:target, user: user) }

  describe 'presence validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:latitude) }
    it { should validate_presence_of(:longitude) }
    it { should validate_presence_of(:radius) }
    it { should validate_presence_of(:topic_id) }
    it { should validate_presence_of(:user_id) }
  end

  describe 'belonging validations' do
    it { should belong_to(:user) }
    it { should belong_to(:topic) }
  end
end
