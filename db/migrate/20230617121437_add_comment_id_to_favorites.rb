class AddCommentIdToFavorites < ActiveRecord::Migration[6.1]
  def change
    add_column :favorites, :comment_id, :integer
  end
end
