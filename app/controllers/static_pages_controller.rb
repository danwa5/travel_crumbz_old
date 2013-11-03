class StaticPagesController < ApplicationController
  include PostsHelper

  before_action :get_latest_posts
  before_action :get_posts_by_countries

  def countries
    if params[:query].blank?
      redirect_to root_path
    else
      @country = params[:query]
      @posts = Post.posts_by_country(@country)
      configure_posts_for_gmaps(@posts)
    end
  end

  private

    def get_latest_posts
      @latest_posts = Post.latest_posts
    end

    def get_posts_by_countries
      @countries = Post.posts_by_countries
    end

end
