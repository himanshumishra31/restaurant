module MealActiveHelper
  def meal_active(meal)
    if meal.active
      "btn-success"
    else
      "btn-danger"
    end
  end
end
