class Tweet < ApplicationRecord
  belongs_to :user
  belongs_to :replied_to, class_name: "Tweet", optional: true, counter_cache: :replies_count

  has_many :likes, dependent: :destroy
  has_many :replies, class_name: "Tweet", foreign_key: :replied_to_id, dependent: :destroy,
                     inverse_of: :replied_to

  # Validations
  validates :body, presence: true, length: { maximum: 140 }
  # replied_to is not required but it should be a valid Tweet id
  validates :replied_to_id, numericality: { only_integer: true, allow_nil: true }
end
