class Admin::BranchesController < Admin::BaseController
  before_action :load_branch, only: [:destroy, :edit, :update, :change_default]

  def new
    @branch = Branch.new
  end

  def create
    @branch = Branch.new(permitted_params)
    if @branch.save
      redirect_with_flash("success", "branch_created", admin_branches_url)
    else
      render :new
    end
  end

  def index
    @branches = Branch.all
    respond_to do |format|
      format.html
      format.csv { send_data @branches.as_csv }
    end
  end

  def update
    if @branch.update(permitted_params)
      redirect_with_flash("success", "successfully_saved", admin_branches_url)
    else
      render :edit
    end
  end

  def change_default
    @branch.change_default_branch
    redirect_with_flash("success", "default_branch", admin_branches_url)
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
      params.require(:branch).permit(:name, :opening_time, :closing_time, :address, :contact_number)
    end

    def load_branch
      @branch = Branch.find_by(id: params[:id])
      unless @branch
        redirect_with_flash("danger", "branch_not_found", admin_branches_url)
      end
    end
end
