class AdminMailer < ApplicationMailer
  default to: -> { AdminUser.pluck(:email) },
          from: 'notification@target.com'

  def contact
    @user = params[:user]
    @contact_form = params[:contact]
    mail(subject: I18n.t('api.email.admin_contact.subject'))
  end
end
