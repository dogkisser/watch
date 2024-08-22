class UsersController < ApplicationController
  def create
    begin
      @user = User.new(user_params)
      @user.save!

      session[:user_id] = @user.id
      redirect_to root_path
    rescue
      render :new, status: :unprocessable_entity
    end
  end

  def new
    @user = User.new
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end
end