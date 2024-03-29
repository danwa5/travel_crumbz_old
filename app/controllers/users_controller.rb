class UsersController < ApplicationController

  before_action :signed_in_user, except: [:new, :create]
  before_action :correct_user,   only: [:show, :edit, :update]
  before_action :admin_user,     only: [:destroy]

  def index
    @users= User.excludes(:id => @current_user.id)

    @friends = Array.new
    current_user.friendships.each do |friendship|
      @friends << friendship.acceptor
    end

    @friended_by = Array.new
    current_user.inverse_friendships.each do |inv_friendship|
      @friended_by << inv_friendship.requester
    end
    
    @strangers = @users - @friends - @friended_by
    #users = User.paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
    @user.build_preference
  end
  
  def create
    @user = User.new(user_params)
    @user.preference = {}

    if @user.save
      sign_in @user
      flash[:success] = "Welcome to Travel Crumbz!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "User profile updated!"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:last_name, :first_name, :email, :about_me, :admin, :avatar,
                                   :remember_token, :password, :password_confirmation, 
                                   preference_attributes: [:id, :display_tiles, :sort_key, :sort_order])
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # def correct_user_or_friend
    #   @user = User.find(params[:id])
    #   unless current_user?(@user)
    #     @friends = Array.new
    #     current_user.friendships.each do |friendship|
    #       @friends << friendship.acceptor
    #     end

    #     unless @friends.include? @user
    #       redirect_to(root_url)
    #     end
    #   end
    # end
    
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
    
end
