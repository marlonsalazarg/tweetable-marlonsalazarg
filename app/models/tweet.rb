class Tweet < ApplicationRecord
  belongs_to :user
  belongs_to :replied_to, class_name: "Tweet", optional: true, counter_cache: :replies_count

  has_many :likes, dependent: :destroy
  has_many :replies, class_name: "Tweet", foreign_key: :replied_to_id, dependent: :destroy,
                     inverse_of: :replied_to

  scope :top_level, -> { where(replied_to_id: nil) }
  scope :with_author, -> { includes(user: { avatar_attachment: :blob }) }

  # Validations
  validates :body, presence: true, length: { maximum: 140 }
  # replied_to is optional, but when given it must be an existing tweet. Not `:replied_to_id?`:
  # junk like "abc" casts to 0, which that predicate treats as absent.
  validates :replied_to, presence: { message: "must be an existing tweet" },
                         if: -> { replied_to_id.present? }

  # Permissions: only the author edits; the author or an admin can delete. `user` may be nil.
  def editable_by?(user)
    user.present? && user_id == user.id
  end

  def deletable_by?(user)
    user.present? && (user_id == user.id || user.admin?)
  end
end
