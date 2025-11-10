Rails.application.config.session_store :cookie_store,
  key: "_stickerbook_session",
  httponly: true,
  same_site: :lax,
  secure: false
# 本番環境では下記の設定に変更
# secure: Rails.env.production?
