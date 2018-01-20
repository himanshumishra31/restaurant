class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :current_user

  def authorize
    redirect_with_flash("danger", "login_to_continue", login_url) unless current_user
  end

  def current_user
    @current_user ||= load_current_user
  end

  def load_current_user
    if cookies.encrypted[:user_id]
      user = User.find_by(id: cookies.encrypted[:user_id])
      if user
        session[:user_id] = user.id
        @current_user = user
      end
    elsif session[:user_id]
      @current_user = User.find_by(id: session[:user_id])
    end
  end

  def redirect_with_flash(type, message_name, path = nil)
    flash[type] = t(message_name, scope: [:controller, params[:controller], params[:action], :flash, type])
    redirect_to path if path
  end

  def set_branch
    cookies[:current_location] = Branch.find_by(default: true).name unless cookies[:current_location]
    @branch = Branch.find_by(name: cookies[:current_location])
  end
end
