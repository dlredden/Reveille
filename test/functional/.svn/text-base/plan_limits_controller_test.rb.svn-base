require 'test_helper'

class PlanLimitsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:plan_limits)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create plan_limit" do
    assert_difference('PlanLimit.count') do
      post :create, :plan_limit => { }
    end

    assert_redirected_to plan_limit_path(assigns(:plan_limit))
  end

  test "should show plan_limit" do
    get :show, :id => plan_limits(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => plan_limits(:one).to_param
    assert_response :success
  end

  test "should update plan_limit" do
    put :update, :id => plan_limits(:one).to_param, :plan_limit => { }
    assert_redirected_to plan_limit_path(assigns(:plan_limit))
  end

  test "should destroy plan_limit" do
    assert_difference('PlanLimit.count', -1) do
      delete :destroy, :id => plan_limits(:one).to_param
    end

    assert_redirected_to plan_limits_path
  end
end
