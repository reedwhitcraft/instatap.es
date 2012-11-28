class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authorize_user

  helper_method :current_user
  
  def current_user
    if @current_user
      @current_user = @current_user
    elsif session[:user_id]
      @current_user = User.find(session[:user_id])
    elsif cookies[:remember_token]
      @current_user = User.find_by_remember_token(cookies[:remember_token])
    else
      @current_user = nil
    end
  end

  def authorize_user
    redirect_to root_url if current_user.nil?
  end
end



