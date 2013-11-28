class PhotosController < ApplicationController

  def index
    @post = Post.find(params[:post_id])
    @photos = @post.photos.all
  end

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
      if @photo.image.blank?
        flash[:danger] = "Photo could not be added to post! Please select a JPG image."
      else
        flash[:danger] = "Photo could not be added to post!"
      end
    end

    redirect_to user_post_path(@post.user, @post)
  end

  def serve
    path = "tmp/uploads/photo/image/#{params[:photo_id]}/#{params[:filename]}.jpg"
    send_file path, disposition: 'inline', type: 'image/jpg', x_sendfile: true

    # id = params[:photo_id]
    # fname = params[:filename]
    # send_file "tmp/uploads/photo/image/" + id + "/" + fname + ".jpg",
    #   disposition: 'inline', type: 'image/jpg', x_sendfile: true
  end

  private

    def photo_params
      params.require(:photo).permit(:id, :image, :caption)
    end

end
