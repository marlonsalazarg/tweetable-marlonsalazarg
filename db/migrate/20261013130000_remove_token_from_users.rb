# The column came from has_secure_token, which nothing ever read.
class RemoveTokenFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_index :users, :token, unique: true
    remove_column :users, :token, :string
  end
end
