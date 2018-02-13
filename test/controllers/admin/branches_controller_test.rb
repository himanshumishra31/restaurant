require 'test_helper'

class BranchesControllerTest < ActionDispatch::IntegrationTest

  test "should get new branch page" do
    post login_url, params: { email: User.third.email, password: '1234567' }
    get new_admin_branch_path
    assert_response :success
  end

  test "should create branch with valid values" do
    post login_url, params: { email: User.third.email, password: '1234567' }
    post admin_branches_path, params: { branch: { name: 'Abcd', opening_time: '2', closing_time: '3', address: '3/11 abcd east', contact_number: '9654208158' } }
    assert_redirected_to admin_branches_url
    assert_equal 'Branch has been successfully created', flash[:success]
  end

  test "should show error if branch validation fails" do
    post login_url, params: { email: User.third.email, password: '1234567' }
    post admin_branches_path, params: { branch: { name: '', opening_time: '2', closing_time: '3', address: '3/11 abcd east', contact_number: '9654208158' } }
    assert_template :new
  end

  test "should open index page" do
    post login_url, params: { email: User.third.email, password: '1234567' }
    get admin_branches_path
    assert_response :success
  end

  test "should open edit page" do
    post login_url, params: { email: User.third.email, password: '1234567' }
    get edit_admin_branch_path(Branch.first)
    assert_response :success
  end

  test "should update branch with valid details" do
    post login_url, params: { email: User.third.email, password: '1234567' }
    patch admin_branch_path(Branch.first), params: { branch: { name: 'abcd '} }
    assert_redirected_to admin_branches_url
    assert_equal "Changes have been successfully saved", flash[:success]
  end

  test "should show errors if value is not valid" do
    post login_url, params: { email: User.third.email, password: '1234567' }
    patch admin_branch_path(Branch.first), params: { branch: { name: ''} }
    assert_template :edit
  end

  test "should delete destroy successfully" do
    post login_url, params: { email: User.third.email, password: '1234567' }
    delete admin_branch_path(Branch.first)
    assert_redirected_to admin_branches_url
    assert_equal 'Branch has been successfully destroyed', flash[:success]
  end

  test "should change default action" do
    post login_url, params: { email: User.third.email, password: '1234567' }
    patch change_default_admin_branch_path(Branch.first)
    assert_redirected_to admin_branches_url
    assert_equal 'Successfully updated default branch.', flash[:success]
  end
end
