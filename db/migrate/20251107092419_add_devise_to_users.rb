class AddDeviseToUsers < ActiveRecord::Migration[8.0]
  def change
    change_table :users, bulk: true do |t|
      ## Database authenticatable
      # emailカラムは既に存在しているためコメントアウト
      # t.string :email,              null: false, default: "" unless column_exists?(:users, :email)
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at
    end

    # add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
  end
end
