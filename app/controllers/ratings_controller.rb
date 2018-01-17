class RatingsController < ApplicationController

  def create_rating(value, review)
    @rating.value = value
    @rating.review = review
    @rating.save
  end

  def rate_meals
    params[:ratings].each do |rating_params|
      if rating_params[:value].present?
        @meal = Meal.find_by(id: rating_params[:meal_id])
        @rating = Rating.find_or_initialize_by(meal_id: @meal.id, user_id: current_user.id)
        if @rating.id.blank?
          create_rating(rating_params[:value].to_i, rating_params[:review])
        else
          @rating.update_columns(value: rating_params[:value].to_i, review: rating_params[:review])
        end
      end
    end
    redirect_with_flash("success", "thanks", store_index_path)
  end

end
