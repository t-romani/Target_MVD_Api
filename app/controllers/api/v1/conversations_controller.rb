module Api
  module V1
    class ConversationsController < Api::V1::ApiController
      helper_method :user, :conversations

      def index; end

      def user
        @user ||= current_user
      end

      def conversations
        @conversations ||= Conversation.with_unread_messages_count_for(user.id)
      end
    end
  end
end
