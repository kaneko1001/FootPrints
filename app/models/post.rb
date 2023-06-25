class Post < ApplicationRecord

  validates :title, presence: true, length: { maximum: 30 }
  validates :content, presence: false, length: { maximum: 300 }
  validates :departure_date, presence: true
  validates :return_date, presence: true

  has_many_attached :images
  has_one_attached :profile_image

  belongs_to :customer

  has_many :favorites, dependent: :destroy
  has_many :favorite_posts, through: :favorites, source: :post

  has_many :comments, dependent: :destroy

  # 投稿機能に画像も投稿
  def get_image(width, height, shape = "rectangle")
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_post_image.jpeg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
  end

  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_user_image.jpeg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

  # 旅行期間を計算
  def trip_duration
    days = (return_date - departure_date).to_i
    years = days / 365
    months = (days % 365) / 30
    remaining_days = (days % 365) % 30

    {
      days: days,
      years: years,
      months: months,
      remaining_days: remaining_days
    }
  end

  # 出発日
  def formatted_departure_date
    departure_date.strftime("%Y年%m月%d日")
  end

  # 帰国日
  def formatted_return_date
    return_date.strftime("%Y年%m月%d日")
  end

  # 並び替え機能
  def self.sort_index(sort)
    case sort
    # 投稿の古い順に並び替え
    when 'old'
      order(created_at: :asc)
    # 投稿のいいねが多い順に並び替え
    when 'favorite_count'
      left_joins(:favorites).group('posts.id').order('COUNT(favorites.id) DESC')
    # 投稿のコメントが多い順に並び替え
    when 'comment_count'
      left_joins(:comments).group('posts.id').order('COUNT(comments.id) DESC')
    else
      # 投稿の新しい順に並び替え
      order(created_at: :desc)
    end
  end

end
