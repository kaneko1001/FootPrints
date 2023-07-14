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
    image.variant(resize_to_fill: [width, height]).processed
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
    days = (return_date - departure_date).to_i + 1
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

  enum prefecture: {
    hokkaido: 1,
    aomori: 2,
    iwate: 3,
    miyagi: 4,
    akita: 5,
    yamagata: 6,
    fukushima: 7,
    ibaraki: 8,
    tochigi: 9,
    gunma: 10,
    saitama: 11,
    chiba: 12,
    tokyo: 13,
    kanagawa: 14,
    niigata: 15,
    toyama: 16,
    ishikawa: 17,
    fukui: 18,
    yamanashi: 19,
    nagano: 20,
    gifu: 21,
    shizuoka: 22,
    aichi: 23,
    mie: 24,
    shiga: 25,
    kyoto: 26,
    osaka: 27,
    hyogo: 28,
    nara: 29,
    wakayama: 30,
    tottori: 31,
    shimane: 32,
    okayama: 33,
    hiroshima: 34,
    yamaguchi: 35,
    tokushima: 36,
    kagawa: 37,
    ehime: 38,
    kochi: 39,
    fukuoka: 40,
    saga: 41,
    nagasaki: 42,
    kumamoto: 43,
    oita: 44,
    miyazaki: 45,
    kagoshima: 46,
    okinawa: 47
  }

  def self.prefecture_options_for_select
    Post.prefectures.map { |key, value| [value, key] }
  end
end
