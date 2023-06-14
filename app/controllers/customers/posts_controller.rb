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
    @post_comment = Comment.new
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(customer_params)
      redirect_to customer_path(@customer), notice: "編集に成功しました。"
    else
      render :edit
    end
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

  def destroy
    @post = Post.find(params[:id])
    @customer = Customer.find(@post.customer_id)
    @post.destroy
    redirect_to customer_path(@customer), notice: "削除に成功しました。"
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :location, :map_latitude, :map_longitude, :departure_date, :return_date, images: [] )
  end
end
