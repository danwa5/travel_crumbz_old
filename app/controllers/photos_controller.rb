class PhotosController < ApplicationController

  def new
    @post = Post.find(params[:post_id])
    @photo = @post.photos.build
  end

  def create
    @post = Post.find(params[:post_id])
    @photo = @post.photos.build(photo_params)

    if (@photo.save)
      flash[:success] = "Photo successfully added to post!"
    else
      flash[:warning] = "Photo could not be added to post!"
    end

    redirect_to user_post_path(@post.user, @post)
  end

  private

    def photo_params
      params.require(:photo).permit(:id, :image, :caption)
    end

end
