DeviseTokenAuth.setup do |config|
  config.default_confirm_success_url = '/'
  config.default_password_reset_url = ENV['PASSWORD_RESET_URL']
  config.change_headers_on_each_request = false
end
