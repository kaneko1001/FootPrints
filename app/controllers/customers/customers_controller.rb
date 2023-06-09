class Customers::CustomersController < ApplicationController

  def index
    @customer = Customer.page(params[:page])
  end

  def show
    @customer = Customer.find(params[:id])
    @posts = @customer.posts
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :profile_image, :introduction, :status)
  end
end
