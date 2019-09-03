Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'api/v1/users', controllers: {
    registrations:  'api/v1/registrations',
    sessions:       'api/v1/sessions',
    confirmations:  'api/v1/confirmations',
    passwords:      'api/v1/passwords'
  }

  namespace :api do
    namespace :v1, defaults: { format: :json } do
      devise_scope :user do
        resources :users, only: :update
        resources :topics, only: :index
        resources :targets, only: %i[create index destroy]
      end
    end
  end
end
