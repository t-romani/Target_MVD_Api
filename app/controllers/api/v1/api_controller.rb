module Api
  module V1
    class ApiController < ApplicationController
      include ActAsApi
      include DeviseTokenAuth::Concerns::SetUserByToken

      before_action :authenticate_user!

      rescue_from ArgumentError, with:
        :render_error_response
      rescue_from ActiveRecord::RecordInvalid, with:
        :render_error_response

      def render_error_response(error)
        render json: { error: error }, status: 400
      end
    end
  end
end
