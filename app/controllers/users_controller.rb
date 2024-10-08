class UsersController < ApplicationController
  def index

  end

  def show

  end

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

  def edit

  end

  def update

  end

  def destroy

  end

  private

  def user_params
    # TODO: there are warnings about unauthorised parameters (:authenticity_token and :commit) but
    # for some reason Rails isn't doing its ParamsWrapper thing automatically like its supposed to
    # Gray: It's not supposed to, that way all of your params are explicit. Avoids being able to inject changes for
    # columns you shouldn't be able to touch if you do something silly like User.create(params) in a controller action
    # Gray 2: You probably want `params.require(:users).permit(:username, :password, :password_confirmation)`
    params.require(:user).permit(:username, :password, :password_confirmation)
  end
end