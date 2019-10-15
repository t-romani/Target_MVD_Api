module Api
  module V1
    class UsersController < Api::V1::ApiController
      helper_method :user

      def update
        user.update!(user_params)
        render :show
      end

      def user
        @user ||= current_user
      end

      private

      def user_params
        params.require(:user).permit(:full_name, :gender, avatar: [:data])
      end
    end
  end
end
