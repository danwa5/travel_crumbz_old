class CommentsController < ApplicationController
  before_action :load_post
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  # GET /comments
  # GET /comments.json
  def index
    @comments = @post.comments.all
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    #@comment = Comment.new
    @comment = @post.comments.build
  end

  # GET /comments/1/edit
  def edit
  end

  def create
    #@comment = Comment.new(comment_params)
    @comment = @post.comments.build(comment_params)
    @comment.rating = params[:score]

    if (@comment.save)
      flash[:success] = "Comment successfully added to post!"
    else
      flash[:warning] = "Comment could not be added to post!"
    end

    redirect_to @post
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    @comment.rating = params[:score]

    respond_to do |format|
      if @comment.update_attributes(comment_params)
        flash[:success] = "Comment successfully updated!"
        format.html { redirect_to @post, notice: 'Comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to post_comments_url(@post) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      #@comment = Comment.find(params[:id])
      @comment = @post.comments.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:rating, :body)
    end

    def load_post
      @post = Post.find(params[:post_id])
    end
end
