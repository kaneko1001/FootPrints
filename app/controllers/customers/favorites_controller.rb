class Customers::FavoritesController < ApplicationController

  before_action :set_post, only: [:create, :destroy]

  def create
    @post = Post.find(params[:post_id])
    favorite = Favorite.new(post_id: @post.id, customer_id: current_customer.id)
    favorite.save
  end

  def destroy
    @post = Post.find(params[:post_id])
    favorite = current_customer.favorites.find_by(post_id: @post.id)
    favorite.destroy
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

end
