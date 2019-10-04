module Api
  module V1
    class InformationsController < Api::V1::ApiController
      skip_before_action :authenticate_user!

      def show
        @information = Information.find_by(title: params[:title])
      end
    end
  end
end
