class StaticPagesController < ApplicationController
  include PostsHelper

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

end
