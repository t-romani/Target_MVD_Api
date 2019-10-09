module Api
  module V1
    class SessionsController < DeviseTokenAuth::SessionsController
      include ActAsApi

      helper_method :user

      def facebook
        user_params = FacebookService.new(params[:access_token]).profile
        @resource = User.from_social_provider('facebook', user_params)
        custom_sign_in
      rescue Koala::Facebook::AuthenticationError
        render json: {
          error: I18n.t('api.error.invalid_request.not_authorized')
        }, status: :forbidden
      rescue ActiveRecord::RecordNotUnique
        render json: {
          error: I18n.t('api.error.invalid_request.already_registered')
        }, status: :bad_request
      end

      def custom_sign_in
        sign_in(:user, @resource)
        new_auth_header = @resource.create_new_auth_token
        response.headers.merge!(new_auth_header)
        render_create_success
      end

      def sign_in_params
        params.require(:user).permit(:email, :password)
      end

      def render_create_success
        set_player_id
        render 'api/v1/users/show'
      end

      def user
        @user ||= current_user
      end

      private

      def set_player_id
        return if current_user.player_id.present?

        NotificationService.new(current_user).set_id
      end
    end
  end
end
