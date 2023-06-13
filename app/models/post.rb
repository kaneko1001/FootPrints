class Post < ApplicationRecord

  has_many_attached :images
  has_one_attached :image

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
    # 投稿履歴でで正方形で表示
    if shape == "square"
      image.variant({gravity: :center, resize: "#{width}x#{height}^", crop: "#{width}x#{height}+0+0"}).processed
    else
      image.variant(resize_to_limit: [width, height]).processed
    end
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
end
