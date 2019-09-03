module Api
  module V1
    class TopicsController < Api::V1::ApiController
      def index
        @topics = Topic.all
      end

      private

      def topic_params
        params.require(:topic).permit(:title, :image)
      end
    end
  end
end
