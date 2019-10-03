module Api
  module V1
    module Conversations
      class MessagesController < Api::V1::ApiController
        include Pagy::Backend

        helper_method :conversation, :user

        def create
          @message = MessageService.new(conversation).create_message(
            message_params['text'], current_user
          )
          render 'api/v1/messages/show'
        end

        def index
          @pagy, @messages = pagy(conversation.messages.order_desc)
          render 'api/v1/messages/index'
        end

        def conversation
          @conversation ||= current_user.conversations
                                        .find(params[:conversation_id])
        end

        def user
          @user ||= current_user
        end

        private

        def message_params
          params.require(:message).permit(
            :text
          )
        end
      end
    end
  end
end
