class Admin::BranchesController < Admin::BaseController
  before_action :set_branch, only: [:destroy, :edit, :update]

  def new
    @branch = Branch.new
  end

  def create
    @branch = Branch.new(permitted_params)
    if @branch.save
      redirect_with_flash("success", "branch_created", admin_branches_url)
    else
      render 'new'
    end
  end

  def index
    @branches = Branch.all
  end

  def update
    if @branch.update(permitted_params)
      redirect_with_flash("success", "successfully_saved", admin_branches_url)
    else
      render 'edit'
    end
  end

  def destroy
    if @branch.destroy
      redirect_with_flash("success", "successfully_destroyed", admin_branches_url)
    else
      redirect_with_flash("danger", "error_destroy", admin_branches_url)
    end
  end

  private
    def permitted_params
      params.require(:branch).permit(:name, :opening_time, :closing_time, :address, :contact)
    end

    def set_branch
      @branch = Branch.find_by(id: params[:id])
      redirect_with_flash("danger", "branch_not_found", admin_branches_url) unless @branch
    end
end
