class Admin::BaseController < ApplicationController
  before_action :ensure_only_admin_can_access

  def ensure_only_admin_can_access
    unless @current_user.role == 'admin'
      flash_message("danger", "access_restricted")
      redirect_to login_url
    end
  end
end
