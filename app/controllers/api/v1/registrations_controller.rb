module Api
  module V1
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
      include ActAsApi

      def sign_up_params
        params.require(:user)
              .permit(:email, :full_name, :gender, :password,
                      :password_confirmation)
      end

      def render_create_success
        render json: { user: resource_data }
      end
    end
  end
end
