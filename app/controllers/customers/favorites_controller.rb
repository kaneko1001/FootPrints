class Customers::FavoritesController < ApplicationController

  def create
    post = Post.find(params[:post_id])
    favorite = Favorite.new(post_id: post.id, customer_id: current_customer.id)
    favorite.save
    redirect_to post_path(post)
  end

  def destroy
    post = Post.find(params[:post_id])
    favorite = current_customer.favorites.find_by(post_id: post.id)
    favorite.destroy
    redirect_to post_path(post)
  end

end
