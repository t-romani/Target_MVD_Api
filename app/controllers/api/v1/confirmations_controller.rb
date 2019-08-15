module Api
  module V1
    class ConfirmationsController < DeviseTokenAuth::ConfirmationsController
      include ActAsApi

    end
  end
end
