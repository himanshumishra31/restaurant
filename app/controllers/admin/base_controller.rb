class Admin::BaseController < ApplicationController
  before_action :ensure_only_admin_can_access

  def ensure_only_admin_can_access
    redirect_with_flash("danger", "access_restricted", login_url) unless @current_user.role == 'admin'
  end
end
