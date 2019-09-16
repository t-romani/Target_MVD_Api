RSpec.shared_context 'conversation_between_two_users', shared_context: :metadata do
  let!(:user)          { create(:user) }
  let!(:topic)         { create(:topic) }
  let(:target)         { create(:target, topic_id: topic.id, user: user) }
  let!(:auth_headers)  { auth_user_headers }
  let!(:another_user)  { create(:user) }
  let(:another_target) do
    create(:target,
           topic_id: topic.id,
           user: another_user,
           latitude: target.latitude,
           longitude: target.longitude)
  end
  let(:conversation) { Conversation.last }

  before do
    WebMock.stub_request(:post, 'https://onesignal.com/api/v1/notifications')
           .to_return(status: 200)
    target
    another_target
    conversation
  end
end
