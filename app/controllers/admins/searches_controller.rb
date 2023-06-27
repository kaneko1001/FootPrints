class Admins::SearchesController < ApplicationController

  before_action :authenticate_admin!

  def search
    @content = params[:content]
    @customers = Customer.search_all_customers(@content)
    @posts = Post.joins(:customer).where("posts.title LIKE ? OR posts.content LIKE ?", "%#{@content}%", "%#{@content}%")
  end
end
