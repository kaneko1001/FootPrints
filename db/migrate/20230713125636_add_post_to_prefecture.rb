class AddPostToPrefecture < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :prefecture, :integer
  end
end
