class PostsController < ApplicationController
  include PostsHelper
  #include SessionsHelper
  
  before_action :signed_in_user
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @all_posts = Post.where(:user_id => @current_user).sort("start_date DESC")

    @posts = Post.starred_posts(@current_user)
    configure_posts_for_gmaps(@posts)
  end

  def show
    get_city_avg_rating(@post.location.city)

    lat2 = @post.location.coordinates[1]
    lng2 = @post.location.coordinates[0]
    @dist = GeoDistance::Haversine.geo_distance( 43.6425662, -79.3870568, lat2, lng2 )
  end

  def new
    @post = Post.new
    @post.build_location
  end

  def edit
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = @current_user.id

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render action: 'show', status: :created, location: @post }
      else
        format.html { render action: 'new' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    #@post.user_id = @current_user.id
    if @post.update_attributes(post_params)
      flash[:success] = "Post successfully updated!"
      redirect_to @post
    else
      render action: 'edit'
    end
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end

  def like
    @post = Post.find(params[:post_id])
    if @post.likes.nil?
      likes_count = 0
    else
      likes_count = @post.likes
    end
    @post.update_attribute(:likes, likes_count+1)
    redirect_to @post
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    def get_city_avg_rating(city)
      match = {"$match" => {"location.city" => city}}
      unwind = {"$unwind" => "$comments"}
      group = {"$group" => {"_id" => {"city" => "$location.city", "country" => "$location.country"}, "avg_rating" => {"$avg" => "$comments.rating"}}}
      @city_avg_rating = Post.collection.aggregate([match, unwind, group])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:user_id, :title, :body, :starred, :start_date, :end_date, :likes, :loves,
        location_attributes: [:id, :street, :city, :state, :country, :postal])
    end

end
