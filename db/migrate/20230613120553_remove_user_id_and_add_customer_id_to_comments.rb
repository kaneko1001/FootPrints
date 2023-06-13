class RemoveUserIdAndAddCustomerIdToComments < ActiveRecord::Migration[6.1]
  def change
    remove_column :comments, :user_id, :integer
    add_column :comments, :customer_id, :integer
  end
end
