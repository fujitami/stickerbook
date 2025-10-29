class AddDetailsToOwnerships < ActiveRecord::Migration[8.0]
  def change
    add_index :ownerships, [:user_id, :sticker_id], unique: true
  end
end
