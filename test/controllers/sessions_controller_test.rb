require 'test_helper'
require 'ostruct'

class SessionsControllerTest < ActionController::TestCase
  setup do
    @user = User.create(user_params(authy_id: "123"))
  end

  teardown do
    @user.destroy
  end

  test "should get new" do
    get :new
    assert_response :success
    assert assigns(:user)
  end

  test "should post to create successfully" do
    Authy::OneTouch
      .expects(:send_approval_request)
      .with(id: '123', message: 'Request to Login to Twilio demo app', details: {'Email Address' => 'blah@example.com'})
      .returns('sucess' => true)
      .once

    post :create, email: @user.email, password: user_params[:password]
    assert_response :success
    assert_equal @user.id, session["pre_2fa_auth_user_id"]
  end

  test "should post to create unsuccessfully" do
    Authy::OneTouch.expects(:send_approval_request).never
    post :create, email: @user.email, password: "blah"
    assert_response :success
    assert_template :new
    assert_nil session["pre_2fa_auth_user_id"]
  end

  test "should get destroy" do
    session["user_id"] = @user.id
    assert session["user_id"], "Precondition: user should be logged in"
    get :destroy
    assert_response :redirect
    assert_redirected_to root_path
    assert_nil session["user_id"]
  end
end
