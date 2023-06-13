class Customers::PostsController < ApplicationController

  def index
    @posts = Post.all
    @customer = current_customer
  end

  def new
    @post = Post.new
  end

  def show
    @post = Post.find(params[:id])
    @customer = Customer.find(@post.customer_id)
  end

  def create
    @post = Post.new(post_params)
    @post.customer_id = current_customer.id
    if @post.save
      flash[:notice] = "投稿に成功しました。"
      redirect_to post_path(@post.id)
    else
      @posts = Post.all
      render :new
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :location, :map_latitude, :map_longitude, :departure_date, :return_date, images: [] )
  end
end
