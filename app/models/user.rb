class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable
  has_secure_token
  before_create :default_avatar

  # Associations
  has_many :tweets, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_tweets, through: :likes, source: :tweet

  # Validations
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :username, presence: true, uniqueness: true
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  validates :password, length: { minimum: 6 }

  # Enums
  enum role: { member: 0, admin: 1 }

  # ActiveStorage
  has_one_attached :avatar

  def self.from_omniauth(auth_hash)
    where(provider: auth_hash.provider, uid: auth_hash.uid).first_or_create do |user|
      user.provider = auth_hash.provider
      user.uid = auth_hash.uid
      user.username = auth_hash.info.nickname
      user.name = auth_hash.info.name
      user.email = auth_hash.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end

  private

  def default_avatar
    return if avatar.attached?

    avatar.attach(io: File.open("app/assets/images/default_avatar.png"),
                  filename: "default_avatar.png")
  end
end
