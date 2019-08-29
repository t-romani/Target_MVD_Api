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

  describe 'validations' do
    it { is_expected.to  validate_presence_of(:title) }
    it { is_expected.to  validate_uniqueness_of(:title).ignoring_case_sensitivity }

    context 'when image is nil' do
      let!(:topic) { create(:topic, image: nil) }

      it 'has default image' do
        expect(topic.image.attached?).to eq(true)
      end
    end
  end
end
