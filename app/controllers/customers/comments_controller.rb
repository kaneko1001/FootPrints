class Customers::CommentsController < ApplicationController

  def create
    post = Post.find(params[:post_id])
    comment = current_customer.comments.new(post_comment_params)
    comment.post = post
    comment.save
    redirect_to post_path(post)
  end

  private

  def post_comment_params
    params.require(:comment).permit(:comment)
  end
end