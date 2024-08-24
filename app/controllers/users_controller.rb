class UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
    else
      flash[:errors] = @user.errors.full_messages
    end

    redirect_to request.referer
  end

  def new
    @user = User.new
  end

  private

  def user_params
    # TODO: there are warnings about unauthorised parameters (:authenticity_token and :commit) but
    # for some reason Rails isn't doing its ParamsWrapper thing automatically like its supposed to
    params.permit(:username, :password, :password_confirmation)
  end
end