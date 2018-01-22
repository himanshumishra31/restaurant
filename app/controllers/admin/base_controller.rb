class Admin::BaseController < ApplicationController
  before_action :ensure_admin

  private
    def ensure_admin
      redirect_with_flash("danger", "access_restricted", store_index_url ) unless @current_user && @current_user.admin?
    end
end
