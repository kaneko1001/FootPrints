class AddCommentToFavorites < ActiveRecord::Migration[6.1]
  def change
    add_column :favorites, :comment, :text
  end
end
