class Like < ApplicationRecord
  belongs_to :user
  belongs_to :tweet, counter_cache: true
  # One like per user and tweet (also enforced by a unique index).
  validates :user_id, uniqueness: { scope: :tweet_id }
end
