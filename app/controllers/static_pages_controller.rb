class StaticPagesController < ApplicationController
  include PostsHelper
  include ApplicationHelper

  before_action :signed_in_user

  def countries
    if params[:query].blank?
      redirect_to root_path
    else
      @country = params[:query]
      @posts = Post.posts_by_country(@current_user, @country)
      configure_posts_for_gmaps(@posts)
    end
  end

  def archive
    if !valid_month(params[:month]) || !valid_year(params[:year])
      redirect_to root_path
    else
      @month = params[:month]
      @year = params[:year]

      @posts_d = Post.posts_by_travel_date(@current_user, @month, @year)
      configure_posts_for_gmaps(@posts_d)
    end
  end

end
