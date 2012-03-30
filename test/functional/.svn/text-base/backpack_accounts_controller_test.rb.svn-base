require 'test_helper'

class BackpackAccountsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:backpack_accounts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create backpack_account" do
    assert_difference('BackpackAccount.count') do
      post :create, :backpack_account => { }
    end

    assert_redirected_to backpack_account_path(assigns(:backpack_account))
  end

  test "should show backpack_account" do
    get :show, :id => backpack_accounts(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => backpack_accounts(:one).to_param
    assert_response :success
  end

  test "should update backpack_account" do
    put :update, :id => backpack_accounts(:one).to_param, :backpack_account => { }
    assert_redirected_to backpack_account_path(assigns(:backpack_account))
  end

  test "should destroy backpack_account" do
    assert_difference('BackpackAccount.count', -1) do
      delete :destroy, :id => backpack_accounts(:one).to_param
    end

    assert_redirected_to backpack_accounts_path
  end
end
