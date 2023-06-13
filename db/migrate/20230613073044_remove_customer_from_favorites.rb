class RemoveCustomerFromFavorites < ActiveRecord::Migration[6.1]
  def change
    remove_column :favorites, :customer, :integer
  end
end
