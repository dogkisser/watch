class SessionsController < ApplicationController
  def new
    @session = Session.new
  end

  def create
    if session_form.valid?
      session[:user_id] = session_form.id
      redirect_to root_path, notice: 'Logged in!'
    else
      render :new, alert: 'Try again, I dare you.'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Logged out!'
  end

  private

  def session_form
    @session ||= Session.new(params.require(:session).permit(:username, :password))
  end
end
