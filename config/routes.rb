Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  ExceptionHunter.routes(self)
  mount_devise_token_auth_for 'User', at: '/api/v1/users', controllers: {
    registrations: 'api/v1/registrations',
    sessions: 'api/v1/sessions',
    passwords: 'api/v1/passwords'
  }

  namespace :api do
    namespace :v1, defaults: { format: :json } do
      get :status, to: 'api#status'
      mount ActionCable.server => '/cable'
      devise_scope :user do
        resource :user, only: %i[update show]
      end
      resources :settings, only: [] do
        get :must_update, on: :collection
      end
      resources :topics, only: %i[index]
      resources :targets, only: %i[create index destroy]
      resources :conversations, only: %i[index] do
        resources :messages, only: %i[index create]
      end
    end
  end
end
