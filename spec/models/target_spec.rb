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

require 'rails_helper'

describe Target, type: :model do
  let!(:user) { create(:user) }

  subject { build(:target, user: user) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:latitude) }
    it { is_expected.to validate_presence_of(:longitude) }
    it { is_expected.to validate_presence_of(:radius) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:topic) }
  end

  describe 'methods' do
    let!(:second_user)     { create(:user) }
    let!(:topic)           { create(:topic) }
    let!(:target_params)   { attributes_for(:target) }
    let!(:second_target) do
      create(:target, user: second_user, topic: topic,
                      radius: 0,
                      latitude: target_params[:latitude],
                      longitude: target_params[:longitude])
    end

    describe '.check_matching_targets' do
      context 'when targets match' do
        subject do
          create(:target, user: user, topic: topic,
                          latitude: target_params[:latitude],
                          longitude: target_params[:longitude])
        end

        it 'calls for notification job' do
          ActiveJob::Base.queue_adapter = :test
          subject
          expect(NotifyRequestJob).to have_been_enqueued
        end
      end

      context 'when targets dont match' do
        subject do
          create(:target, user: user, topic: topic,
                          radius: 0,
                          latitude: target_params[:latitude] + 10,
                          longitude: target_params[:longitude] + 10)
        end

        it 'returns without calling any jobs' do
          ActiveJob::Base.queue_adapter = :test
          subject
          expect(NotifyRequestJob).not_to(have_been_enqueued)
        end
      end
    end

    describe '.matches?' do
      context 'when targets match' do
        let(:args) { [[], second_target] }

        subject do
          build(:target, latitude: target_params[:latitude],
                         longitude: target_params[:longitude],
                         user: user, topic: topic)
        end

        it 'returns true' do
          expect(subject.send(:matches?, *args)).to eq(true)
        end
      end

      context 'when targets dont match' do
        let(:args) { [[second_user], second_target] }

        subject do
          build(:target, latitude: target_params[:latitude],
                         longitude: target_params[:longitude],
                         user: user, topic: topic)
        end

        it 'returns false' do
          expect(subject.send(:matches?, *args)).to eq(false)
        end
      end
    end
  end
end
