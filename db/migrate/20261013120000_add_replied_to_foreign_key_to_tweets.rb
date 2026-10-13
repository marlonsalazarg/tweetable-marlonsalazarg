class AddRepliedToForeignKeyToTweets < ActiveRecord::Migration[7.0]
  def up
    # Replies whose parent no longer exists can't satisfy the key; keep them as top-level tweets.
    execute <<~SQL.squish
      UPDATE tweets SET replied_to_id = NULL
      WHERE replied_to_id IS NOT NULL
        AND replied_to_id NOT IN (SELECT id FROM tweets)
    SQL
    add_foreign_key :tweets, :tweets, column: :replied_to_id
  end

  def down
    remove_foreign_key :tweets, column: :replied_to_id
  end
end
