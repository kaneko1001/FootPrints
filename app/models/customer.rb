class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, uniqueness: true, length: { in: 2..20 }
  validates :introduction, length: { maximum: 50 }

  has_one_attached :profile_image

  has_many :posts, dependent: :destroy

  has_many :favorites, dependent: :destroy
  has_many :favorite_posts, through: :favorites, source: :post

  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :reverse_of_relationships, source: :follower

  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followings, through: :relationships, source: :followed

  has_many :comments, dependent: :destroy

  # フォロー関係
  def follow(customer_id)
    relationships.create(followed_id: customer_id)
  end

  def unfollow(customer_id)
    relationships.find_by(followed_id: customer_id).destroy
  end

  def following?(customer)
    followings.include?(customer)
  end

  # いいね関係
  def favorited_by?(post)
    favorites.exists?(post_id: post.id)
  end

  # プロフィール写真
  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_user_image.jpeg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

  # 退会処理
  def active_for_authentication?
    super && (is_deleted == false)
  end

  # ゲストログイン
  def self.guest
    Customer.find_or_create_by!(name: 'guestuser', email: 'guest@example.com') do |customer|
      customer.password = SecureRandom.urlsafe_base64
      customer.name = "guestuser"
    end
  end

  # 検索機能
  def self.search_for(content)
    if content.present?
      where('name LIKE ?', "%#{content}%").order(created_at: :desc)
    else
      order(created_at: :desc)
    end
  end

  def self.search_active_customers(content)
    where(is_deleted: false).search_for(content)
  end

  def self.search_all_customers(content)
    search_for(content)
  end

end
