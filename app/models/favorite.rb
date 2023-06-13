class Favorite < ApplicationRecord

  belongs_to :customer
  belongs_to :post
  validates_uniqueness_of :post_id, scope: :customer_id
  
  def favorited_by?(customer)
    favorites.exists?(customer_id: customer.id)
  end
end
