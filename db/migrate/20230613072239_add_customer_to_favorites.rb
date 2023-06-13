class AddCustomerToFavorites < ActiveRecord::Migration[6.1]
  def change
    add_column :favorites, :customer, :integer
  end
end
