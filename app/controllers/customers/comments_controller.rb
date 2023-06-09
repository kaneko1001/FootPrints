class Customers::CommentsController < ApplicationController

  before_action :set_comment, only: [:destroy]

  def create
    @post = Post.find(params[:post_id])
    @comment = current_customer.comments.new(post_comment_params)
    @comment.post = @post
    @comment.save
    respond_to do |format|
      format.html { redirect_to post_path(@post) }
      format.js
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @post = @comment.post
    @comment.destroy
    # redirect_to post_path(post)
  end

  private

  def post_comment_params
    params.require(:comment).permit(:comment)
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end
end