class Favorite < ApplicationRecord

  belongs_to :customer
  belongs_to :post
  validates_uniqueness_of :post_id, scope: :user_id
end
