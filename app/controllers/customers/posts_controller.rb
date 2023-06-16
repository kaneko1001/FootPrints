class Customers::PostsController < ApplicationController

  before_action :authenticate_customer!, except: [:index, :show]
  before_action :is_matching_login_user, only: [:edit, :update]

  def index
    @posts = Post.joins(:customer).where(customers: { is_deleted: false })
    @customer = current_customer
  end

  def new
    @post = Post.new
  end

  def show
    @post = Post.find(params[:id])
    @customer = Customer.find(@post.customer_id)
    if @customer.is_deleted
      redirect_to root_path, notice: "投稿情報は表示できません。"
    else
      @post_comment = Comment.new
    end
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

  def is_matching_login_user
    post = Post.find(params[:id])
    unless post.customer_id == current_customer.id
      flash[:alert] = "他ユーザーの投稿編集画面には遷移できません。"
      redirect_to post_path(post.id)
    end
  end
end
