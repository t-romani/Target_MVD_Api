module Api
  module V1
    class TargetsController < Api::V1::ApiController
      helper_method :user

      def create
        @target = Target.create! target_params
        @target.save
        render :show
      end

      def user
        @user ||= current_user
      end

      private

      def target_params
        params.require(:target).permit(
          :topic_id,
          :user_id,
          :title,
          :radius,
          :latitude,
          :longitude
        )
      end
    end
  end
end
