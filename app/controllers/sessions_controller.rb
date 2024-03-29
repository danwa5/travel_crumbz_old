class SessionsController < ApplicationController
  include SessionsHelper

  def new
    if signed_in?
      redirect_to root_url
    else
      render 'new'
    end
  end
  
  def create
    user = User.where(:email => params[:session][:email].downcase).first

    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end
  
  def destroy
    sign_out
    redirect_to root_url
  end
  
end
