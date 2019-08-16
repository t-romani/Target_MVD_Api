module Api
  module V1
    class ApiController < ApplicationController::API
      include DeviseTokenAuth::Concerns::SetUsedByToken

      before_action :authenticate_user!
    end
  end
end
