require 'test_helper'

class Admin::ReportsControllerTest < ActionDispatch::IntegrationTest

  setup do
    post login_url, params: { email: User.find(23).email, password: '1234567' }
    assert_redirected_to store_index_url
  end

  test "should open reports page with default dates" do
    get admin_reports_path
    assert_response :success
  end

  test "should open reports page with params dates" do
    get admin_reports_path, params: { from_date: { year: 2017, month: 12, day: 28}, to_date: { year: 2018, month: 1, day: 10} }
    assert_response :success
  end
end
