class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include SessionsHelper

  before_action :get_user_info
  before_action :get_latest_posts
  before_action :get_posts_by_countries
  before_action :get_posts_by_travel_dates

  def get_user_info
    if params[:user_id].present?
      user = User.find(params[:user_id])
      @profile_user = user
    else
      @profile_user = current_user
    end
  end

  def get_latest_posts
    @latest_posts = Post.latest_posts(@profile_user)
  end

  def get_posts_by_countries
    @countries = Post.posts_by_countries(@profile_user)
  end

  def get_posts_by_travel_dates
    @archives = Post.posts_by_travel_dates(@profile_user)
  end
end
