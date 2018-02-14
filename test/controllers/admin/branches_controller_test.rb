require 'test_helper'

class BranchesControllerTest < ActionDispatch::IntegrationTest

  setup do
    post login_url, params: { email: User.find(23).email, password: '1234567' }
    assert_redirected_to store_index_url
  end

  test "should get new branch page" do
    get new_admin_branch_path
    assert_response :success
  end

  test "should create branch with valid values" do
    post admin_branches_path, params: { branch: { name: 'Abcd', opening_time: '2', closing_time: '3', address: '3/11 abcd east', contact_number: '9654208158' } }
    assert_redirected_to admin_branches_url
    assert_equal 'Branch has been successfully created', flash[:success]
  end

  test "should show error if branch validation fails" do
    post admin_branches_path, params: { branch: { name: '', opening_time: '2', closing_time: '3', address: '3/11 abcd east', contact_number: '9654208158' } }
    assert_template :new
  end

  test "should open index page" do
    get admin_branches_path
    assert_response :success
  end

  test "should open edit page" do
    get edit_admin_branch_path(Branch.first)
    assert_response :success
  end

  test "should update branch with valid details" do
    patch admin_branch_path(Branch.first), params: { branch: { name: 'abcd '} }
    assert_redirected_to admin_branches_url
    assert_equal "Changes have been successfully saved", flash[:success]
  end

  test "should show errors if value is not valid" do
    patch admin_branch_path(Branch.first), params: { branch: { name: ''} }
    assert_template :edit
  end

  test "should delete destroy successfully" do
    delete admin_branch_path(Branch.first)
    assert_redirected_to admin_branches_url
    assert_equal 'Branch has been successfully destroyed', flash[:success]
  end

  test "should show error is branch is not found" do
    delete admin_branch_path(0)
    assert_redirected_to admin_branches_url
    assert_equal 'Branch not found. Please try again', flash[:danger]
  end

  test "should change default action" do
    patch change_default_admin_branch_path(Branch.first)
    assert_redirected_to admin_branches_url
    assert_equal 'Successfully updated default branch.', flash[:success]
  end
end
