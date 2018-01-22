class Admin::BaseController < ApplicationController
  before_action :ensure_admin

  # FIX_ME_PG:- make this private method.
  def ensure_admin
    redirect_with_flash("danger", "access_restricted", login_url) unless @current_user.admin?
  end
end
