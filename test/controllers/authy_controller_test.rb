require 'test_helper'
require 'ostruct'

class AuthyControllerTest < ActionController::TestCase
  setup do
    @user = User.create(user_params(authy_id: "123"))
  end

  teardown do
    @user.destroy
  end

  test "should post to callback successfully" do
    post :callback, authy_id: '123', status: 'approved'
    @user.update(authy_status: @request.params[:status])
    assert @user.approved?, "User should be updated"
    assert_response :success
  end

  test "should get one_touch_status successfully" do
    session["pre_2fa_auth_user_id"] = @user.id
    get :one_touch_status
    assert_response :success
  end

  test "should post to send_token successfully" do
    session["pre_2fa_auth_user_id"] = @user.id
    Authy::API.expects(:request_sms).with(id: "123").once
    post :send_token
    assert_response :success
  end

  test "should post to verify successfully" do
    session["pre_2fa_auth_user_id"] = @user.id
    verify = OpenStruct.new(:ok? => true)
    Authy::API.expects(:verify).with(
      id: @user.authy_id,
      token: '123456'
    ).once.returns(verify)
    post :verify, token: '123456'
    assert_response :redirect
    assert_redirected_to account_path
    assert_nil session["pre_2fa_auth_user_id"]
    assert_equal session[:user_id], @user.id
  end

  test "should post to verify unsuccessfully" do
    session["pre_2fa_auth_user_id"] = @user.id
    verify = OpenStruct.new(:ok? => false)
    Authy::API.expects(:verify).with(
      id: @user.authy_id,
      token: '123456'
    ).once.returns(verify)
    post :verify, token: '123456'
    assert_response :redirect
    assert_redirected_to new_session_path
  end

end
