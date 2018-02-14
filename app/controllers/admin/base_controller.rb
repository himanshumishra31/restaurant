class Admin::BaseController < ApplicationController
  before_action :ensure_admin

  private
    def ensure_admin
      unless @current_user.admin?
        redirect_with_flash("danger", "access_restricted", store_index_url )
      end
    end
end
