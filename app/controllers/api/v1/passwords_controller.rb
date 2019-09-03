module Api
  module V1
    class PasswordsController < DeviseTokenAuth::PasswordsController
      include ActAsApi

      helper_method :user

      def render_update_success
        render :update
      end

      def user
        @user ||= current_user
      end
    end
  end
end
