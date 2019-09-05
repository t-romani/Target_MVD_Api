module Api
  module V1
    class SessionsController < DeviseTokenAuth::SessionsController
      include ActAsApi

      def sign_in_params
        params.require(:user).permit(:email, :password)
      end

      def render_create_success
        set_user_player_id if current_user.player_id.nil?
        render json: { user: resource_data }
      end

      def set_user_player_id
        NotificationSenderService.new.session_update(current_user)
      end
    end
  end
end
