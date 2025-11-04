Rails.application.routes.draw do
  post   "/signup", to: "users#create"
  post   "/login",  to: "sessions#create"
  delete "/logout", to: "sessions#destroy", defaults: { format: :json }

  # 接続確認用
  root "pages#home"

  # ステッカー関連
  resources :stickers, only: [ :index, :create, :show ] do
    resources :comments, only: [ :index, :create ]
  end

  # ログイン中ユーザーのステッカー一覧
  get "/me/stickers", to: "stickers#my_index"

  # 他ユーザーのステッカー一覧
  resources :users, only: [] do
    resources :stickers, only: [ :index ]
  end

  # 自分の情報・所有関係
  resource :me, only: [ :show ], controller: :me do
    resources :ownerships, only: [ :index ], controller: "me/ownerships"
  end

  # 所有の作成・削除
  resources :ownerships, only: [ :create, :destroy ]
end
