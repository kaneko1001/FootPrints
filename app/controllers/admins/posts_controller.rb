class Admins::PostsController < ApplicationController

  before_action :authenticate_admin!

  def index
    @posts = Post.all
    @customer = current_customer
  end

  def show
    @post = Post.find(params[:id])
  end

  def destroy
    @post = Post.find(params[:id])
    @customer = Customer.find(@post.customer_id)
    @post.destroy
    redirect_to admins_posts_path, notice: "削除に成功しました。"
  end

end
