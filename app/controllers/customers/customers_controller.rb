class Customers::CustomersController < ApplicationController

  before_action :authenticate_customer!
  before_action :is_matching_login_customer, only: [:edit, :update]
  before_action :check_guest_customer, only: [:edit]

  def index
    @customers = Customer.where(is_deleted: false).page(params[:page])
  end

  def show
    @customer = Customer.find(params[:id])
    if @customer.is_deleted
      redirect_to root_path
      flash[:notice] = "ユーザの情報は表示できません。"
    else
      if current_customer
        @posts = @customer.posts.page(params[:page]).per(5)
      else
        @posts = []
      end
    end
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def update
    @customer = Customer.find(params[:id])
    if @customer.update(customer_params)
      redirect_to customer_path(@customer)
      flash[:notice] = "編集に成功しました。"
    else
      render :edit
    end
  end

  def withdrawal
    @customer = current_customer
    @customer.update(is_deleted: true)
    reset_session
    flash[:notice] = "退会処理を実行いたしました"
    redirect_to root_path
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :profile_image, :introduction, :status)
  end

  def is_matching_login_customer
    customer = Customer.find(params[:id])
    unless customer.id == current_customer.id
      flash[:alert] = "他ユーザーの投稿編集画面には遷移できません。"
      redirect_to customer_path(customer.id)
    end
  end

  def check_guest_customer
    @customer = Customer.find(params[:id])
    if @customer.name == "guestuser"
      flash[:alert] = "ゲストユーザーはアクセスできません。"
      redirect_to customer_path(current_customer)
    end
  end
end
