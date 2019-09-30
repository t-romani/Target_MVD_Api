module Api
  module V1
    class TargetsController < Api::V1::ApiController
      helper_method :user, :targets

      def create
        @target = targets.create!(target_params)
        render :show
      end

      def index; end

      def destroy
        targets.find(params[:id]).destroy!
      end

      def user
        @user ||= current_user
      end

      def targets
        @targets ||= user.targets
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
