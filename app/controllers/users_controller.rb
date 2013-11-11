class UsersController < ApplicationController

  before_action :signed_in_user, except: [:new, :create]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:destroy]

  def index
    @users = User.all
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
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to Travel Crumbz!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
    #@user = User.find(params[:id])
  end
  
  def update
    #@user = User.find(params[:id])
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
      params.require(:user).permit(:last_name, :first_name, :email, :admin,
                                   :remember_token, :password, :password_confirmation, 
                                   preference_attributes: [:id, :num_tiles, :sort_key, :sort_order])
    end
    
    # Before filters

    # Defined in Sessions Helper
    #def signed_in_user
    #  unless signed_in?
    #    store_location
    #    redirect_to signin_url, notice: "Please sign in."
    #  end
    #end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
    
end
