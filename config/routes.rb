Rails.application.routes.draw do
  devise_for :users,
            controllers: {
              registrations: "users/registrations",
              sessions: "users/sessions"
            }

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

  # 自分のプロフィール情報
  resource :me, only: [ :show ], controller: :me do
    # 自分が所有しているステッカー
    resources :ownerships, only: [ :index ], controller: "me/ownerships"
  end

  # 所有の作成・削除（他のユーザーの投稿に対しても使う）
  resources :ownerships, only: [ :create, :destroy ]

  # デバッグ
  # セッション情報表示
  get "/debug/session", to: "application#debug_session"
end
