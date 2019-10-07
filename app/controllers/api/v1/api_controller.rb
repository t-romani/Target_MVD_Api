module Api
  module V1
    class ApiController < ActionController::API
      include ActAsApi
      include DeviseTokenAuth::Concerns::SetUserByToken

      before_action :authenticate_user!

      rescue_from ArgumentError, with:
        :render_error_response
      rescue_from ActiveRecord::RecordInvalid, with:
        :render_error_response
      rescue_from ActiveRecord::RecordNotFound, with:
        :render_not_found_response

      def render_error_response(error)
        render json: { error: error }, status: :bad_request
      end

      def render_not_found_response
        render json: {
          error: I18n.t('api.error.invalid_request.content_not_found')
        },
               status: :not_found
      end
    end
  end
end
