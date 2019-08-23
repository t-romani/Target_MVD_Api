Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: '/users', controllers: {
        registrations: 'api/v1/registrations',
        sessions: 'api/v1/sessions'
      }
    end
  end
end
