class AddImagesToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :images, :json
  end
end
