class PostsController < ApplicationController
  include PostsHelper
  include SessionsHelper
  
  before_action :signed_in_user
  before_action :correct_user,   only: [:new, :create, :edit, :update, :destroy]
  before_action :set_user,       only: [:show, :like]
  before_action :set_post,       only: [:show, :edit, :update, :destroy]
  

  def index
    @all_posts = Post.where(:user_id => @profile_user).sort("start_date DESC")

    @posts = Post.posts_with_photos(@profile_user)
    configure_posts_for_gmaps(@posts)
  end

  def show
    @photos = @post.photos.all
    get_post_avg_rating(@post)

    lat2 = @post.location.coordinates[1]
    lng2 = @post.location.coordinates[0]
    @dist = GeoDistance::Haversine.geo_distance( 43.6425662, -79.3870568, lat2, lng2 )
  end

  def new
    @post = @user.posts.build
    @post.build_location
  end

  def create
    @post = @user.posts.build(post_params)

    if @post.save
      flash[:success] = "Post was successfully created."
      redirect_to user_post_path(@post.user, @post)
    else
      render action: 'new'
    end
  end

  def edit
  end

  def update      
    if @post.update_attributes(post_params)
      flash[:success] = "Post successfully updated!"
      redirect_to user_post_path(@user, @post)
    else
      render action: 'edit'
    end
  end

  def destroy
    @post.destroy
    flash[:success] = "Post deleted."
    redirect_to user_posts_path(@user)
  end

  def like
    @post = @user.posts.find(params[:post_id])
    if @post.likes.nil?
      likes_count = 0
    else
      likes_count = @post.likes
    end
    @post.update_attribute(:likes, likes_count+1)
    redirect_to user_post_path(@user, @post)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:user_id])
    end

    def set_post
      @post = @user.posts.find(params[:id])
    end

    def correct_user
      @user = User.find(params[:user_id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def get_post_avg_rating(post)
      match = {"$match" => {"post_id" => post.id}}
      group = {"$group" => {"_id" => "$post_id", "avg_rating" => {"$avg" => "$rating"}}}
      @post_avg_rating = Comment.collection.aggregate([match, group])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:user_id, :title, :body, :starred, :start_date, :end_date, :likes, :loves,
        location_attributes: [:id, :street, :city, :state, :country, :postal],
        photo_attributes: [:id, :photo, :caption])
    end

end
