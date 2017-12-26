class Admin::BranchesController < Admin::BaseController
  before_action :set_branch, only: [:destroy, :edit, :update]

  def new
    @branch = Branch.new
  end

  def create
    @branch = Branch.new(permitted_branch_params)
    if @branch.save
      flash_message("success", "branch_created")
      redirect_to admin_branches_url
    else
      render 'new'
    end
  end

  def index
    @branches = Branch.all
  end

  def update
    if @branch.update(permitted_branch_params)
      flash_message("success", "successfully_saved")
      redirect_to admin_branches_url
    else
      render 'edit'
    end
  end

  def destroy
    @branch.destroy
    redirect_to admin_branches_url
  end

  private
    def permitted_branch_params
      params.require(:branch).permit(:name, :opening_time, :closing_time)
    end

    def set_branch
      @branch = Branch.find_by(id: params[:id])
    end
end
