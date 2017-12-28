class Admin::BranchesController < Admin::BaseController
  before_action :set_branch, only: [:destroy, :edit, :update]
  after_action :set_inventories, only: [:create]

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
    redirect_with_flash("success", "successfully_destroyed", admin_branches_url) if @branch.destroy
  end

  private
    def permitted_params
      params.require(:branch).permit(:name, :opening_time, :closing_time)
    end

    def set_branch
      @branch = Branch.find_by(id: params[:id])
    end

    def set_inventories
      Ingredient.all.each do |ingredient|
        @branch.inventories.build(ingredient_id: ingredient.id).save
      end
    end
end
