require 'test_helper'

class RatingTest < ActiveSupport::TestCase
  setup do
    @new_rating = Rating.new(value: 4, meal_id: meals(:first).id, user_id: users(:first).id, review: 'Good')
  end

  test "should raise error without a value" do
    rating = Rating.new
    assert_not rating.valid?
    assert_equal ["can't be blank"], rating.errors[:value]
  end

  test "should raise error without a review" do
    rating = Rating.new
    assert_not rating.valid?
    assert_equal ["can't be blank"], rating.errors[:review]
  end

  test "should raise error without a user id" do
    rating = Rating.new
    assert_not rating.valid?
    assert_equal ["must exist"], rating.errors[:user]
  end

  test "should raise error without a meal id" do
    rating = Rating.new
    assert_not rating.valid?
    assert_equal ["must exist"], rating.errors[:meal]
  end

  test "should save with valid credentials" do
    assert @new_rating.valid?
    assert_difference "Rating.count", 1 do
      @new_rating.save
    end
  end
end
