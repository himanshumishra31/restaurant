class Admin::ReportsController < Admin::BaseController
  before_action :set_branch
  before_action :set_from_to_date
  before_action :set_low_inventories
  before_action :set_popular_meal

  private
    # FIX_ME_PG:- Controllers are only for handling requests. Lets Discuss this.
    # This should not be here.
    def get_date_from_params(date)
      DateTime.new(date[:year].to_i, date[:month].to_i, date[:day].to_i)
    end

    # to discuss: by default date show in view

    def set_from_to_date
      if params[:from_date].present? && params[:to_date].present?
        @from_date = get_date_from_params(params[:from_date])
        @to_date = get_date_from_params(params[:to_date])
        @orders = @branch.orders.by_date(@from_date, @to_date)
      else
        @orders = @branch.orders.by_date
      end
    end

    def set_low_inventories
      @inventories = @branch.inventories.where('quantity < 2')
    end

    def set_popular_meal
      popular_meal_id = Order.most_sold_meal(@orders)
      @popular_meal = Meal.find_by(id: popular_meal_id)
    end
end
