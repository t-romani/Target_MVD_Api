module Api
  module V1
    class SessionsController < DeviseTokenAuth::SessionsController
      include ActAsApi

      def sign_in_params
        params.require(:user).permit(:email, :password)
      end

      def render_create_success
        set_player_id
        render json: { user: resource_data }
      end

      private

      def set_player_id
        PlayerIdsService.new(current_user).register_for_notification
      end
    end
  end
end
