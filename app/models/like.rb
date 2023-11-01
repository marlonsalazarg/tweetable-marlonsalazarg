class Like < ApplicationRecord
  belongs_to :user
  belongs_to :tweet, counter_cache: true
  # user_id and should be a unique combinationtweet_id
  validates :user_id, uniqueness: { scope: :tweet_id }
end
