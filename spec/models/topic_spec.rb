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

require 'rails_helper'
describe Topic, type: :model do
  subject { build(:topic) }

  describe 'presence validations' do
    it { should validate_presence_of(:title) }

    context 'when image is nil' do
      let!(:topic) { build(:topic, image: nil) }

      it 'isnt valid' do
        expect(topic).not_to be_valid
      end
    end
  end

  describe 'uniqueness' do
    it { should validate_uniqueness_of(:title) }
  end
end
