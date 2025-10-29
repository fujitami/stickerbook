Rails.application.routes.draw do
  post   "/signup", to: "users#create"
  post   "/login",  to: "sessions#create"
  delete "/logout", to: "sessions#destroy", defaults: { format: :json }

  resources :stickers, only: [ :index, :create, :show ]
  resource :me, only: [ :show ], controller: :me do
    resources :ownerships, only: [ :index ], controller: "me/ownerships"
  end
  resources :ownerships, only: [ :create, :destroy ]
end
