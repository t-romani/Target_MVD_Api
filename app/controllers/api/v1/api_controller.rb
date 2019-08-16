module Api
  module V1
    class ApiController < ApplicationController
      include DeviseTokenAuth::Concerns::SetUsedByToken

      before_action :authenticate_user!
<<<<<<< HEAD
=======
      before_action :pepe

      private

      def pepe
        byebug
      end
>>>>>>> add pr2 fixes
    end
  end
end
