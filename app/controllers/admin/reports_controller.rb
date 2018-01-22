class Admin::ReportsController < Admin::BaseController
  before_action :set_branch
  before_action :set_from_to_date

  #FIX_ME_PG:- Load the instance variables in before_filters.
  def index
    @orders = @branch.orders.by_date(@from_date, @to_date)
    popular_meal_id = Order.most_sold_meal(@orders)
    @popular_meal = Meal.find_by(id: popular_meal_id)
    @inventories = @branch.inventories.where('quantity < 2')
  end

  private

  # FIX_ME_PG:- Controllers are only for handling requests. Lets Discuss this.
  # This should not be here.
  def get_date_from_params(date)
    DateTime.new(date[:year].to_i, date[:month].to_i, date[:day].to_i)
  end

  # FIX_ME_PG:- This cosde can be refactored. Also, if default reports will be shown for last 7 days, then some other better logic can be used.
  # Lets discuss this. Also Use Time.current, Date.current instead on Time#now.
  def set_from_to_date
    if params[:from_date].present? && params[:to_date].present?
      @from_date = get_date_from_params(params[:from_date])
      @to_date = get_date_from_params(params[:to_date])
    else
      @from_date = 7.days.ago
      @to_date = Time.now
    end
  end
end
