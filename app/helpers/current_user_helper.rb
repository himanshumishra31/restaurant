module CurrentUserHelper
  def admin_logged_in?
    @current_user && @current_user.admin?
  end
end
