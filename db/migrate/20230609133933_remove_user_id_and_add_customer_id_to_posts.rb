class RemoveUserIdAndAddCustomerIdToPosts < ActiveRecord::Migration[6.1]
  def change
    remove_column :posts, :user_id
    add_column :posts, :customer_id, :integer
  end
end
