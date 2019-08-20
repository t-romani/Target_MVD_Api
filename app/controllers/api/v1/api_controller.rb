module Api
  module V1
    class ApiController < ApplicationController
      include ActAsApi
      include DeviseTokenAuth::Concerns::SetUserByToken

      before_action :authenticate_user!, except: %i[new create]
    end
  end
end
