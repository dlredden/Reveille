require 'test_helper'

class AccountUsersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:account_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create account_user" do
    assert_difference('AccountUser.count') do
      post :create, :account_user => { }
    end

    assert_redirected_to account_user_path(assigns(:account_user))
  end

  test "should show account_user" do
    get :show, :id => account_users(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => account_users(:one).to_param
    assert_response :success
  end

  test "should update account_user" do
    put :update, :id => account_users(:one).to_param, :account_user => { }
    assert_redirected_to account_user_path(assigns(:account_user))
  end

  test "should destroy account_user" do
    assert_difference('AccountUser.count', -1) do
      delete :destroy, :id => account_users(:one).to_param
    end

    assert_redirected_to account_users_path
  end
end
