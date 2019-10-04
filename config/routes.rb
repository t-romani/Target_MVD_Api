Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'api/v1/users', controllers: {
    registrations: 'api/v1/registrations',
    sessions: 'api/v1/sessions',
    confirmations: 'api/v1/confirmations',
    passwords: 'api/v1/passwords'
  }
  namespace :api do
    namespace :v1, defaults: { format: :json } do
      devise_scope :user do
        resources :users, only: :update
        resources :topics, only: :index
        resources :targets, only: %i[create index destroy]
        resources :conversations, only: :index do
          resources :messages, module: :conversations, only: %i[create index]
        end
        resources :contacts, only: :create, path: '/contact'
        resources :informations, param: :title, only: :show, path: ''
      end
    end
  end

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
end
