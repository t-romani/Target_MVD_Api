module Api
  module V1
    class UsersController < Api::V1::ApiController
      def update
        render_update_success if current_user.update!(user_params)
      end

      def render_update_success
        render :update
      end

      private

      def user_params
        params.require(:user).permit(:full_name, :gender)
      end
    end
  end
end
