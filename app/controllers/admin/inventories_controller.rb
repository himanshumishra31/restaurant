class Admin::InventoriesController < Admin::BaseController
  before_action :set_session_branch, only: [:index, :edit, :update]
  before_action :set_branch, only: [:index, :edit, :update]
  before_action :set_inventory, only: [:edit, :update]
  before_action :set_inventories, only: [:index]
  before_action :check_quantity, only: [:update]

  def edit
    set_comments
  end

  def update
    if @inventory.update(permitted_params)
      @inventory.increment!(:quantity, params[:inventory][:quantity].to_i)
      redirect_with_flash("success", "successfully_updated", admin_inventories_path(session[:current_location]))
    else
      set_comments
      render :edit
    end
  end

  private

    def set_inventory
      @inventory = Inventory.find_by(id: params[:id])
    end

    def set_inventories
      @inventories = Inventory.where(branch: @branch)
    end

    def set_session_branch
      cookies[:current_location] = session[:current_location] = params[:branch] if params[:branch]
    end

    def permitted_params
      params.require(:inventory).permit(comments_attributes: [:body, :user_id])
    end

    def set_comments
      @comments = @inventory.comments.includes(:user).limit(ENV["COMMENT_LIMIT"]).order(created_at: :desc)
    end

    def check_quantity
      if @inventory.quantity + params[:inventory][:quantity].to_i < 0
        redirect_with_flash("danger", "invalid_quantity", admin_inventories_path(session[:current_location]))
      end
    end
end
