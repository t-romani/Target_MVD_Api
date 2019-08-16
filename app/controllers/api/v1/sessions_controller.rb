module Api
  module V1
    class SessionsController < DeviseTokenAuth::SessionsController
      include ActAsApi

      def sign_in_params
        params.require(:user).permit(:email, :password)
      end
    end
  end
end
