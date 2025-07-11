class ApplicationController < ActionController::Base
  include Pundit::Authorization
  
  before_action :current_user
  
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  helper_method :current_user

  def require_login
    unless current_user
      flash[:alert] = 'Please log in'
      redirect_to login_path
    end
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_back(fallback_location: root_path)
  end
end