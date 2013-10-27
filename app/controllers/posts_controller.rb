class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :get_latest_posts
  before_action :get_post_countries

  def index
    @all_posts = Post.all
    get_map_pins
  end

  def show
  end

  def new
    @post = Post.new
    #@post.location.build
    @post.build_location
  end

  def edit
  end

  def create
    @post = Post.new(post_params)

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
    #s_date = params[:start_date]
    #:start_date = Date.new(s_date["start_date(1i)"], s_date["start_date(2i)"], s_date["start_date(3i)"])
    #params[:start_date] = Date.new(s_date[:year].to_i, s_date[:month].to_i, s_date[:day].to_i)
    #params[:start_date] = DateTime.new("2013","1","2")

    #respond_to do |format|
      if @post.update_attributes(post_params)
        flash[:success] = "Post successfully updated!"
        redirect_to @post

        #format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        #format.json { head :no_content }
      else
        render action: 'edit'
        #format.html { render action: 'edit' }
      end
    #end
  end

   def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :body, :starred, :start_date, :end_date, :likes, :loves,
        location_attributes: [:id, :street, :city, :state, :country, :postal])
    end

    def get_map_pins
      @pins = String.new
      @posts = Post.where(starred: true)
      @posts.each do |p|
        @pins = @pins + p.location.to_gmaps4rails.to_s
      end

      @pins = @pins.gsub(/\]\[/, ",")
      @pins = @pins.gsub(/"/,"'")
    end

    def get_latest_posts
      @latest_posts = Post.all.sort("created_at DESC").limit(10)
    end

    def get_post_countries
      @post_countries = Post.distinct("location.country").sort()
    end

end
