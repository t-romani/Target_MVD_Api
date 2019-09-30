module Api
  module V1
    class ContactsController < Api::V1::ApiController
      helper_method :user, :admins

      def create
        contact = user.contacts.create!(contact_params)
        AdminMailer.with(user: @user, contact: contact)
                   .contact.deliver_later
      end

      def user
        @user ||= current_user
      end

      def admins
        @admins ||= AdminUser.all
      end

      def contact_params
        params.require(:contact).permit(
          :text,
          :user_id
        )
      end
    end
  end
end
