class FriendshipsController < ApplicationController

  def create
    @friendship = current_user.friendships.build(:acceptor => params[:user_id])
    if @friendship.save
      flash[:success] = "Added friend."
      redirect_to users_path
    else
      flash[:error] = "Unable to add friend."
      redirect_to users_path
    end
  end

  def destroy
    current_user.friendships.find(params[:id]).destroy
    flash[:warning] = "Deleted friend."
    redirect_to users_path
  end

end
