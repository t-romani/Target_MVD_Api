require 'rails_helper'

describe 'POST #create target', type: :request do
  let!(:user)           { create(:user) }
  let!(:auth_headers)   { auth_user_headers }
  let!(:topic)          { create(:topic) }
  let!(:target_params) do
    {
      target: attributes_for(:target,
                             topic_id: topic.id,
                             radius: 1000)
    }
  end

  subject do
    post api_v1_targets_path, params: target_params,
                              headers: auth_headers,
                              as: :json
  end

  context 'when valid' do
    it 'gets a successful answer' do
      subject
      expect(response).to be_successful
    end

    it 'creates the target' do
      expect { subject }.to change(Target, :count).by(1)
    end

    it 'belongs to the user' do
      subject
      expect(Target.last.user_id).to eq(user.id)
    end

    context 'when 2 targets are compatible' do
      let!(:second_user) { create(:user) }
      let!(:second_target) do
        create(:target,
               topic_id: topic.id,
               user: second_user,
               radius: 0.0,
               latitude: target_params[:target][:latitude],
               longitude: target_params[:target][:longitude])
      end

      before do
        WebMock.stub_request(:post, 'https://onesignal.com/api/v1/notifications')
               .to_return(status: 200,
                          body: File.new(
                            'spec/support/fixtures/new_target_match_success.json'
                          ))
      end

      it 'calls notification service function' do
        ActiveJob::Base.queue_adapter = :test
        subject
        expect(NotifyRequestJob).to have_been_enqueued
      end

      context 'regarding conversations' do
        context 'when no conversation between first and second user' do
          it 'creates a conversation between the two users' do
            expect { subject }.to change { Conversation.count }.by(1)
            expect(user.conversations.size).to eq(1)
            expect(second_user.conversations.size).to eq(1)
            expect(user.conversations.first.id)
              .to eq(Conversation.first.id)
            expect(second_user.conversations.first.id)
              .to eq(Conversation.first.id)
          end
          it 'sends matched target message' do
            subject
            expect(Conversation.last.messages.size).to eq(1)
            expect(Conversation.last.messages.last.text)
              .to eq(I18n.t('api.messages.target_match'))
          end

          context 'when new target doesnt match' do
            let!(:no_match_params) do
              {
                target: attributes_for(:target,
                                       topic_id: topic.id,
                                       radius: 0.0,
                                       latitude:
                                        second_target.latitude + 5,
                                       longitude:
                                        second_target.longitude + 5)
              }
            end

            it 'does not create a conversation between the two users' do
              expect {
                post api_v1_targets_path, params: no_match_params,
                                          headers: auth_headers,
                                          as: :json
              }.not_to(change { Conversation.count })
              expect(user.conversations.size).to eq(0)
              expect(second_user.conversations.size).to eq(0)
            end
          end
        end

        context 'when conversation exists between first and second user' do
          let!(:first_target) do
            create(:target,
                   topic_id: topic.id,
                   user: user,
                   latitude: second_target.latitude,
                   longitude: second_target.longitude)
          end

          it 'does not create a conversation between the users' do
            expect { subject }.not_to(change { Conversation.count })
          end
          it 'sends matched target message' do
            expect { subject }.to(change { Conversation.first.messages.count }
              .by(1))
          end

          context 'when new target doesnt match' do
            let!(:no_match_params) do
              {
                target: attributes_for(:target,
                                       topic_id: topic.id,
                                       radius: 0.0,
                                       latitude:
                                        second_target.latitude + 5,
                                       longitude:
                                        second_target.longitude + 5)
              }
            end

            it 'does not create a conversation between the two users' do
              expect {
                post api_v1_targets_path, params: no_match_params,
                                          headers: auth_headers,
                                          as: :json
              }.not_to(change { Conversation.count })
              expect(user.conversations.size).to eq(1)
              expect(second_user.conversations.size).to eq(1)
            end

            it 'does not send matched target message' do
              expect {
                post api_v1_targets_path, params: no_match_params,
                                          headers: auth_headers,
                                          as: :json
              }.not_to(change { Conversation.first.messages.count })
            end
          end
        end

        context 'when 3 users match in between themselves' do
          let!(:third_user) { create(:user) }

          context 'when no conversation between any of the users' do
            let!(:third_target) do
              create(:target,
                     topic_id: topic.id,
                     user: third_user,
                     radius: 0.0,
                     latitude: target_params[:target][:latitude],
                     longitude: target_params[:target][:longitude] + 0.0001)
            end

            it 'creates 2 conversations' do
              expect(Conversation.count).to eq(0)
              expect { subject }.to(change { Conversation.count }.by(2))
            end
            it 'creates 2 new conversations for first user, 1 for others' do
              subject
              expect(user.conversations.count).to eq(2)
              expect(second_user.conversations.count).to eq(1)
              expect(third_user.conversations.count).to eq(1)
            end

            context 'when new target doesnt match' do
              let!(:no_match_params) do
                {
                  target: attributes_for(:target,
                                         topic_id: topic.id,
                                         radius: 0.0,
                                         latitude:
                                          second_target.latitude + 5,
                                         longitude:
                                          second_target.longitude + 5)
                }
              end

              it 'does not create a conversation between any user' do
                expect {
                  post api_v1_targets_path, params: no_match_params,
                                            headers: auth_headers,
                                            as: :json
                }.not_to(change { Conversation.count })
                expect(user.conversations.size).to eq(0)
                expect(second_user.conversations.size).to eq(0)
                expect(third_user.conversations.size).to eq(0)
              end
            end
          end

          context 'when conversation between second and third users created' do
            let!(:third_target) do
              create(:target,
                     topic_id: topic.id,
                     user: third_user,
                     radius: 50.0,
                     latitude: target_params[:target][:latitude],
                     longitude: target_params[:target][:longitude] + 0.0001)
            end

            it 'creates 2 conversations' do
              expect(Conversation.count).to eq(1)
              expect { subject }.to(change { Conversation.count }.by(2))
            end
            it 'creates 2 new conversations for first user, 1 for others' do
              subject
              expect(user.conversations.count).to eq(2)
              expect(second_user.conversations.count).to eq(2)
              expect(third_user.conversations.count).to eq(2)
            end
            it 'sends matched target message on 2 new conversations' do
              expect { subject }.to(change { Message.count }.by(2))
              expect(Conversation.second.messages.size).to eq(1)
              expect(Conversation.third.messages.size).to eq(1)
            end

            context 'when new target doesnt match' do
              let!(:no_match_params) do
                {
                  target: attributes_for(:target,
                                         topic_id: topic.id,
                                         radius: 0.0,
                                         latitude:
                                          second_target.latitude + 5,
                                         longitude:
                                          second_target.longitude + 5)
                }
              end

              it 'does not create a conversation between any user' do
                expect {
                  post api_v1_targets_path, params: no_match_params,
                                            headers: auth_headers,
                                            as: :json
                }.not_to(change { Conversation.count })
                expect(user.conversations.size).to eq(0)
                expect(second_user.conversations.size).to eq(1)
                expect(third_user.conversations.size).to eq(1)
              end
            end
          end

          context 'when conversation in between every user' do
            let!(:third_target) do
              create(:target,
                     topic_id: topic.id,
                     user: third_user,
                     radius: 50.0,
                     latitude: target_params[:target][:latitude],
                     longitude: target_params[:target][:longitude] + 0.0001)
            end

            let!(:first_target) do
              create(:target,
                     topic_id: topic.id,
                     user: user,
                     radius: 50.0,
                     latitude: target_params[:target][:latitude],
                     longitude: target_params[:target][:longitude] + 0.0001)
            end

            it 'does not create any conversation' do
              expect(Conversation.count).to eq(3)
              expect { subject }.not_to(change { Conversation.count })
            end

            it 'sends matched target message on both matched conversations' do
              expect { subject }.to change { Message.count }.by(2)
            end

            context 'when new target doesnt match' do
              let!(:no_match_params) do
                {
                  target: attributes_for(:target,
                                         topic_id: topic.id,
                                         radius: 0.0,
                                         latitude:
                                          second_target.latitude + 5,
                                         longitude:
                                          second_target.longitude + 5)
                }
              end

              it 'does not create a conversation between any user' do
                expect {
                  post api_v1_targets_path, params: no_match_params,
                                            headers: auth_headers,
                                            as: :json
                }.not_to(change { Conversation.count })
                expect(User.first.conversations.size).to eq(2)
                expect(User.second.conversations.size).to eq(2)
                expect(User.third.conversations.size).to eq(2)
              end

              it 'does not sends any match message' do
                expect {
                  post api_v1_targets_path, params: no_match_params,
                                            headers: auth_headers,
                                            as: :json
                }.not_to(change { Message.count })
              end
            end
          end
        end
      end
    end
  end

  context 'when invalid' do
    context 'when not logged in' do
      let!(:auth_headers) { {} }

      it 'gets an unauthorized response' do
        subject
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does not create the target' do
        expect { subject }.not_to change(Target, :count)
      end
    end

    context 'when missing argument' do
      context 'title' do
        before do
          target_params[:target][:title] = nil
        end

        it 'gets a bad request response' do
          subject
          expect(response).to have_http_status(:bad_request)
        end

        it 'returns error message' do
          subject
          expect(parsed_data['error']).to eq(
            "Validation failed: Title can't be blank"
          )
        end

        it 'does not create the target' do
          expect { subject }.not_to change(Target, :count)
        end
      end
    end

    context 'when limit reached' do
      before do
        create_list(:target, 10, user: user, topic: topic)
        subject
      end

      it 'gets a bad_request response' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns limit error' do
        expect(parsed_data['error'])
          .to eq('Validation failed: Unable to create target, limit reached.')
      end
    end
  end
end
