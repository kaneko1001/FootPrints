class Customers::SearchesController < ApplicationController

  before_action :authenticate_customer!

  def search
    @content = params[:content]
    @customers = Customer.search_active_customers(@content).page(params[:page])
    @posts = Post.joins(:customer).where("customers.is_deleted = ? AND (posts.title LIKE ? OR posts.content LIKE ?)", false, "%#{@content}%", "%#{@content}%").page(params[:page])
  end
end
