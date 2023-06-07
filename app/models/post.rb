class Post < ApplicationRecord

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
end
