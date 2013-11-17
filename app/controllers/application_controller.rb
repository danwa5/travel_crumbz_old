class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include SessionsHelper

  before_action :get_latest_posts
  before_action :get_posts_by_countries
  before_action :get_posts_by_travel_dates

  def get_latest_posts
    @latest_posts = Post.latest_posts(self.current_user)
  end

  def get_posts_by_countries
    @countries = Post.posts_by_countries(self.current_user)
  end

  def get_posts_by_travel_dates
    @archives = Post.posts_by_travel_dates(self.current_user)
  end
end
