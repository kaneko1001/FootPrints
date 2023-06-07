class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :profile_image

  has_many :posts, dependent: :destroy

  has_many :favorites, dependent: :destroy
  has_many :favorite_posts, through: :favorites, source: :post

  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :reverse_of_relationships, source: :follower

  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followings, through: :relationships, source: :followed

  has_many :comments, dependent: :destroy

  # プロフィール写真の設定
  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_userimage.jpeg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant({gravity: :center, resize: "#{width}x#{height}^", crop: "#{width}x#{height}+0+0"}).processed
  end

  # フォローする時
  def follow(user)
    relationships.find_or_create_by(followed_id: user.id)
  end

  # フォローを外す時
  def unfollow(user)
    relationships.find_by(followed_id: user.id).destroy
  end

  # フォローしているのか確認
  def following?(user)
    followings.include?(user)
  end
end
