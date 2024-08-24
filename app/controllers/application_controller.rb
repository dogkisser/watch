class ApplicationController < ActionController::Base
  helper_method :current_user

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  # Use as an action callback to prevent the action(s) being used when there is no session/user is not valid for whatever reason.
  def assert_logged_in
    redirect_to root_path, alert: 'Not authorized' unless current_user
  end
end
