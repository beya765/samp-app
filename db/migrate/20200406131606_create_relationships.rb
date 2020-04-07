class CreateRelationships < ActiveRecord::Migration[5.1]
  def change
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end
    # L14.1: relationshipsテーブルにインデックスを追加する
    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
    # follower_idとfollowed_idの組み合わせが必ずユニークであることを保証する
    # (あるユーザーが同じユーザーを2回以上フォローすることを防ぎます)
    add_index :relationships, [:follower_id, :followed_id], unique: true
  end
end
