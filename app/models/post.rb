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
    hokkaido: '北海道',
    aomori: '青森県',
    iwate: '岩手県',
    miyagi: '宮城県',
    akita: '秋田県',
    yamagata: '山形県',
    fukushima: '福島県',
    ibaraki: '茨城県',
    tochigi: '栃木県',
    gunma: '群馬県',
    saitama: '埼玉県',
    chiba: '千葉県',
    tokyo: '東京都',
    kanagawa: '神奈川県',
    niigata: '新潟県',
    toyama: '富山県',
    ishikawa: '石川県',
    fukui: '福井県',
    yamanashi: '山梨県',
    nagano: '長野県',
    gifu: '岐阜県',
    shizuoka: '静岡県',
    aichi: '愛知県',
    mie: '三重県',
    shiga: '滋賀県',
    kyoto: '京都府',
    osaka: '大阪府',
    hyogo: '兵庫県',
    nara: '奈良県',
    wakayama: '和歌山県',
    tottori: '鳥取県',
    shimane: '島根県',
    okayama: '岡山県',
    hiroshima: '広島県',
    yamaguchi: '山口県',
    tokushima: '徳島県',
    kagawa: '香川県',
    ehime: '愛媛県',
    kochi: '高知県',
    fukuoka: '福岡県',
    saga: '佐賀県',
    nagasaki: '長崎県',
    kumamoto: '熊本県',
    oita: '大分県',
    miyazaki: '宮崎県',
    kagoshima: '鹿児島県',
    okinawa: '沖縄県'
  }
end
