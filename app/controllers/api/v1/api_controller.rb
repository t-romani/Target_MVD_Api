module Api
  module V1
    class ApiController < ApplicationController::API
      include DeviseTokenAuth::Concerns::SetUsedByToken

      before_action :authenticate_user!
      before_action :configure_permitted_parameters, if: :devise_controller?

      protected

      def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_in, keys: %i[email])
      end
    end
  end
end
