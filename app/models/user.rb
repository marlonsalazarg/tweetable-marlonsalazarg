class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # :validatable covers email (presence, uniqueness, format via config.email_regexp) and
  # password (presence, confirmation, config.password_length), so they aren't repeated here.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable
  has_secure_token
  before_create :default_avatar

  # Associations
  has_many :tweets, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_tweets, through: :likes, source: :tweet

  # Validations
  # Same rules as GitHub logins, so OAuth nicknames always fit.
  VALID_USERNAME_REGEX = /\A[a-zA-Z0-9_-]+\z/
  AVATAR_TYPES = %w[image/png image/jpeg image/gif image/webp].freeze
  AVATAR_MAX_SIZE = 2.megabytes

  validates :username, presence: true, length: { maximum: 39 },
                       format: { with: VALID_USERNAME_REGEX,
                                 message: "can only contain letters, numbers, - and _" },
                       uniqueness: { case_sensitive: false }
  validates :name, presence: true, length: { maximum: 50 }
  validate :avatar_is_an_image

  # Enums
  enum role: { member: 0, admin: 1 }

  # ActiveStorage
  has_one_attached :avatar

  def self.from_omniauth(auth_hash)
    where(provider: auth_hash.provider, uid: auth_hash.uid).first_or_create do |user|
      user.provider = auth_hash.provider
      user.uid = auth_hash.uid
      user.username = available_username(auth_hash.info.nickname, auth_hash.uid)
      # A GitHub profile name is optional; fall back to the login.
      user.name = auth_hash.info.name.presence || auth_hash.info.nickname
      user.email = auth_hash.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end

  # The GitHub login, or login + uid when someone here already took it.
  def self.available_username(nickname, uid)
    exists?(["LOWER(username) = ?", nickname.to_s.downcase]) ? "#{nickname}_#{uid}" : nickname
  end

  private

  def default_avatar
    return if avatar.attached?

    avatar.attach(io: File.open(Rails.root.join("app/assets/images/default_avatar.png")),
                  filename: "default_avatar.png", content_type: "image/png")
  end

  # Uploads are served back from our own domain, so only accept small raster images
  # (no SVG/HTML, which a browser could execute).
  def avatar_is_an_image
    return unless avatar.attached?

    errors.add(:avatar, "must be a PNG, JPEG, GIF or WebP image") unless
      avatar.blob.content_type.in?(AVATAR_TYPES)
    errors.add(:avatar, "must be smaller than 2 MB") if avatar.blob.byte_size > AVATAR_MAX_SIZE
  end
end
