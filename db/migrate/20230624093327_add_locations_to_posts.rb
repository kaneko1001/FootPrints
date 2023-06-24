class AddLocationsToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :locations, :json
  end
end
