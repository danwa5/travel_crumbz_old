class PhotosController < ApplicationController
  include SessionsHelper

  before_action :signed_in_user
  before_action :correct_user,   only: [:new, :create, :edit, :update, :destroy]
  before_action :set_post,       only: [:index, :new, :create, :edit, :update, :destroy]
  before_action :set_photo,      only: [:edit, :update, :destroy]

  def index
    @photos = @post.photos.all
    @testing = @post.testing
  end

  def new
    @photo = @post.photos.build
  end

  def create
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

  def edit
  end

  def update
    if @photo.update_attributes(photo_params)

      # if current photo is the cover, all other photos in post should not be cover
      if @photo.cover_photo == true
        other_photos = @post.photos - @photo.to_a
        other_photos.each do |other_photo|
          other_photo.update_attribute(:cover_photo, false)
        end
      end

      flash[:success] = "Photo successfully updated!"
      redirect_to user_post_photos_path(@post.user, @post)
    else
      render action: 'edit'
    end
  end

  def destroy
    @photo.destroy
    flash[:success] = "Photo deleted."
    redirect_to user_post_photos_path(@photo.post.user, @photo.post)
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

    def set_post
      @post = Post.find(params[:post_id])
    end

    def set_photo
      @photo = @post.photos.find(params[:id])
    end

    def correct_user
      @user = User.find(params[:user_id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def photo_params
      params.require(:photo).permit(:id, :image, :caption, :cover_photo)
    end

end
