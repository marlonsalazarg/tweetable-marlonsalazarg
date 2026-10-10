class AddUniqueIndexToLikes < ActiveRecord::Migration[7.0]
  def up
    execute <<~SQL.squish
      DELETE FROM likes
      WHERE id NOT IN (SELECT MIN(id) FROM likes GROUP BY user_id, tweet_id)
    SQL
    add_index :likes, %i[user_id tweet_id], unique: true
    execute <<~SQL.squish
      UPDATE tweets
      SET likes_count = (SELECT COUNT(*) FROM likes WHERE likes.tweet_id = tweets.id)
    SQL
  end

  def down
    remove_index :likes, %i[user_id tweet_id]
  end
end
