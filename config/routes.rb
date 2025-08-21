Rails.application.routes.draw do
  post   "/signup", to: "users#create"
  post   "/login",  to: "sessions#create"
  delete "/logout", to: "sessions#destroy", defaults: { format: :json }

  resource :me, only: [:show], controller: :me 

  resources :stickers, only: [:index, :create, :show]
end
