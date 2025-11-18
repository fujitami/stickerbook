# おたがいシール帳 (stickerbook)

つくったシールを見せあって、おすそ分けできるシンプルな Web アプリケーション。

こちらは Rails バックエンドです。

※フロントエンドは別リポジトリで管理しています: `https://github.com/fujitami/stickerbook-next`。

## 目的

シール（ステッカー）を投稿・一覧表示・詳細閲覧し、他ユーザーに「もらう（所有）」アクションを行えるようにする。

## 主な機能

- シール投稿（画像 + キャプション）
- シール一覧・詳細表示
- コメント（シールごと）
- 所有状態（Ownership）の切り替え
- 自身の所有するシール一覧

**注意**: フロントエンド（Next.js）とクロスオリジンで連携するため、Cookie / CORS / SameSite 設定に注意が必要です。開発時は `http://localhost:3000`（Next dev） と `http://localhost:3001`（Rails dev） を使う前提で記載しています。

## Tech

- **Backend**: Rails 8 / Ruby 3.4 / ActiveRecord / ActiveStorage
- **DB**: SQLite（開発） / PostgreSQL（本番を想定）
- **Auth**: Devise（サインイン／サインアウト）
- **Frontend**: Next.js 15 (TypeScript) / Tailwind CSS（別リポジトリ）

## 開発環境（Backend）

### 前提

- Ruby（3.4 系）と Bundler がインストールされていること
- Node / npm または pnpm（フロントを起動する場合）

### セットアップ

```bash
# 依存 gem をインストール
bundle install

# データベース作成・マイグレーション
bin/rails db:create db:migrate

# ローカル開発サーバ起動（ポート 3001）
bin/rails server -p 3001
```

### 開発時の注意

- Rails 側は API として動くエンドポイントを提供します。フロントは `NEXT_PUBLIC_API_BASE` にこのバックエンドの URL を設定して利用します。
- CORS 設定は `config/initializers/cors.rb` で `http://localhost:3000` を許可しており、`credentials: true` にしています。フロントからは `fetch(..., { credentials: 'include' })` を付与して Cookie を送信してください。

## Frontend (開発用) の起動方法（参考）

- フロントは別リポジトリ: `https://github.com/fujitami/stickerbook-next`
- ローカルでの起動例（フロント側リポジトリで実行）:

```bash
# 初回: 依存インストール
npm install

# 開発サーバ起動
rm -rf .next
npm run dev
```

フロントは `NEXT_PUBLIC_API_BASE` 環境変数で API のベース URL（例: `http://localhost:3001`）を参照します。

## 環境変数

- Backend:
  - `FRONTEND_ORIGIN` (例: `http://localhost:3000`)
- Frontend:
  - `NEXT_PUBLIC_API_BASE` (例: `http://localhost:3001`)

## セッション / 認証に関する補足

- 開発中は `config/initializers/session_store.rb` で `same_site: :lax`、`secure: false` に設定しています。
- 本番でクロスオリジンの API を使う場合は HTTPS を使用し、`same_site: :none` と `secure: true` を検討してください。

## API（主なエンドポイント）

- `POST /signup` — ユーザー登録
- `POST /login` または Devise の `POST /users/sign_in` — サインイン
- `DELETE /logout` — サインアウト
- `GET /stickers` — ステッカー一覧
- `GET /stickers/:id` — ステッカー詳細（`owned` と `ownership_id` を含む）
- `POST /stickers/:id/comments` — コメント作成
- `POST /ownerships` — 所有作成
- `DELETE /ownerships/:id` — 所有削除

（詳細は `config/routes.rb` を参照してください）

## デプロイ

- 本番環境では PostgreSQL と外部ストレージ（S3 等）を使うことを推奨します。
- 環境変数、Devise のシークレットやメール設定、ActiveStorage の設定を本番用に用意してください。

## 貢献・連絡先

- Issue や Pull Request を歓迎します。大きな変更を加える場合は事前に Issue で相談してください。

---

この README はローカル開発とフロントエンド連携を念頭に作成しています。フロント側の実装やデプロイ要件に合わせて随時更新してください。
