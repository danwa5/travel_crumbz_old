class StaticPagesController < ApplicationController
  include PostsHelper
  include ApplicationHelper

  before_action :signed_in_user
  before_action :correct_user,   only: [:overview]

  def countries
    if params[:query].blank?
      redirect_to root_path
    else
      @country = params[:query]
      @posts = Post.posts_by_country(@profile_user, @country)
      configure_posts_for_gmaps(@posts)
    end
  end

  def archive
    if !valid_month(params[:month]) || !valid_year(params[:year])
      redirect_to root_path
    else
      @month = params[:month]
      @year = params[:year]

      @posts_d = Post.posts_by_travel_date(@profile_user, @month, @year)
      configure_posts_for_gmaps(@posts_d)
    end
  end

  def overview
    @posts = Post.all_posts(@profile_user)
  end

  private

    def correct_user
      @user = User.find(params[:user_id])
      redirect_to(root_url) unless current_user?(@user)
    end

end
