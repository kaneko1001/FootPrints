class Admins::CustomersController < ApplicationController
  
  before_action :authenticate_admin!

  def index
    @customers = Customer.all.order(created_at: :desc).page(params[:page])
  end

  def show
    @customer = Customer.find(params[:id])
    @posts = @customer.posts
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def update
    @customer = Customer.find(params[:id])
    if @customer.update(customer_params)
      redirect_to admins_customer_path(@customer), notice: "編集に成功しました。"
    else
      render :edit
    end
  end

  def withdrawal
    @customer = current_customer
    @customer.update(is_deleted: true)
    reset_session
    flash[:notice] = "退会処理を実行いたしました"
    redirect_to admins_customer_path
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :introduction, :is_deleted)
  end

end
