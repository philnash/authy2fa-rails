class AuthyController < ApplicationController
  protect_from_forgery except: [:authy_callback, :send_token]

  # The webhook setup for our Authy application this is where
  # the response from a OneTouch request will come
  def callback
    authy_id = params[:authy_id]
    begin
      @user = User.find_by! authy_id: authy_id
      @user.update(authy_status: params[:status])
    rescue => e
      puts e.message
    end
    render plain: 'OK'
  end

  def one_touch_status
    @user = User.find(session[:pre_2fa_auth_user_id])
    session[:user_id] = @user.approved? ? @user.id : nil
    render text: @user.authy_status
  end

  def send_token
    @user = User.find(session[:pre_2fa_auth_user_id])
    Authy::API.request_sms(id: @user.authy_id)
    render plain: 'sending token'
  end
end
