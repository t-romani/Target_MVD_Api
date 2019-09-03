module Api
  module V1
    class TargetsController < Api::V1::ApiController
      helper_method :user

      def create
        @target = user.targets.create!(target_params)
        render :show
      end

      def user
        @user ||= current_user
      end

      private

      def target_params
        params.require(:target).permit(
          :topic_id,
          :title,
          :radius,
          :latitude,
          :longitude
        )
      end
    end
  end
end
