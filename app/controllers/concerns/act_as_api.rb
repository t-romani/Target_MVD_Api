module ActAsApi
  extend ActiveSupport::Concern

  included do
    include ActionController::RequestForgeryProtection
    protect_from_forgery with: :exception, unless: -> { request.format.json? }
    skip_before_action :verify_authenticity_token
    before_action :check_json_request
  end

  def check_json_request
    return if request_content_type && request_content_type&.match?(/json/)

    render json: { error: I18n.t('api.error.invalid_request.content_type') },
           status: :not_acceptable
  end

  def request_content_type
    request.content_type
  end
end
