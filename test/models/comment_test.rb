require 'test_helper'

class CommentTest < ActiveSupport::TestCase

  setup do
    @new_comment = Comment.new(user_id: users(:first).id, inventory_id: inventories(:first).id, body: 'add')
    @comment = Comment.new
  end

  test "should raise error if body is not present" do
    assert_not @comment.valid?
    assert_equal ["can't be blank"], @comment.errors[:body]
  end

  test "should raise error if user id is not given" do
    assert_not @comment.valid?
    assert_equal ["must exist"], @comment.errors[:user]
  end

  test "should raise error if inventory id is not given" do
    assert_not @comment.valid?
    assert_equal ["must exist"], @comment.errors[:inventory]
  end

  test "should raise error if wrong user id is given" do
    comment = Comment.new(user_id: 1)
    assert_not comment.valid?
    assert_equal ["must exist"], comment.errors[:user]
  end

  test "should raise error if wrong inventory id is given" do
    comment = Comment.new(inventory_id: 1)
    assert_not comment.valid?
    assert_equal ["must exist"], comment.errors[:inventory]
  end

  test "should save with valid credentials" do
    assert @new_comment.valid?
    assert_difference 'Comment.count', 1 do
      @new_comment.save
    end
  end
end
