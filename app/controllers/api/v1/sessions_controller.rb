module Api
  module V1
    class SessionsController < DeviseTokenAuth::SessionsController
      include ActAsApi
    end
  end
end
