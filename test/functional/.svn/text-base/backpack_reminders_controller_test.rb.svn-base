require 'test_helper'

class BackpackRemindersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:backpack_reminders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create backpack_reminder" do
    assert_difference('BackpackReminder.count') do
      post :create, :backpack_reminder => { }
    end

    assert_redirected_to backpack_reminder_path(assigns(:backpack_reminder))
  end

  test "should show backpack_reminder" do
    get :show, :id => backpack_reminders(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => backpack_reminders(:one).to_param
    assert_response :success
  end

  test "should update backpack_reminder" do
    put :update, :id => backpack_reminders(:one).to_param, :backpack_reminder => { }
    assert_redirected_to backpack_reminder_path(assigns(:backpack_reminder))
  end

  test "should destroy backpack_reminder" do
    assert_difference('BackpackReminder.count', -1) do
      delete :destroy, :id => backpack_reminders(:one).to_param
    end

    assert_redirected_to backpack_reminders_path
  end
end
