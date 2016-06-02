class UsersController < ApplicationController

  def show
    @user = User.find(params[:id]) # if
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params[:user])
    if @user.save
      ###
      redirect_to @user
    else
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end