class CommentsController < ApplicationController
  before_action :signed_in_user
  before_action :set_post
  before_action :set_comment, only: [:edit, :update, :destroy]

  def new
    @comment = @post.comments.build
  end

  def create
    @comment = @post.comments.build(comment_params)
    @comment.rating = params[:score]
    @comment.user_id = @current_user.id

    if (@comment.save)
      flash[:success] = "Comment successfully added to post!"
    else
      flash[:danger] = "Comment could not be added to post! Rating is a required field."
    end

    redirect_to user_post_path(@post.user, @post)
  end

  def edit
  end

  def update
    @comment.rating = params[:score]

    if @comment.update_attributes(comment_params)
      flash[:success] = "Comment successfully updated!"
      redirect_to user_post_path(@post.user, @post)
    else
      render action: 'edit'
    end
  end

  def destroy
    @comment.destroy
    redirect_to user_post_comments_path(@post.user, @post)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:post_id])
    end

    def set_comment
      @comment = @post.comments.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:rating, :body, :post_id, :user_id)
    end
    
end
