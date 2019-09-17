module StoreHelper
  def meal_rated?(meal)
    meal.ratings.present?
  end

  def average_rating(meal)
    meal.ratings.average(:value)
  end
end
