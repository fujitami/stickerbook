class CreateStickers < ActiveRecord::Migration[8.0]
  def change
    create_table :stickers do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :caption
      t.boolean :public

      t.timestamps
    end
  end
end
