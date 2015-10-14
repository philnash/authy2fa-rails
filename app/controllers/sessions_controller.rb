class SessionsController < ApplicationController
  protect_from_forgery except: [:authy_callback, :send_token]

  def new
    @user = User.new
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      session[:pre_2fa_auth_user_id] = @user.id
      
      # Try to verify with OneTouch, will return response body
      one_touch = @user.send_one_touch

      render json: one_touch
    else
      @user ||= User.new(email: params[:email])
      render :new
    end
  end

  # The webhook setup for our Authy application this is where
  # the response from a OneTouch request will come
  def authy_callback
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

  def two_factor
    return redirect_to new_session_path unless session[:pre_2fa_auth_user_id]
  end

  def verify
    @user = User.find(session[:pre_2fa_auth_user_id])
    token = Authy::API.verify(id: @user.authy_id, token: params[:token])
    if token.ok?
      session[:user_id] = @user.id
      session[:pre_2fa_auth_user_id] = nil
      redirect_to account_path
    else
      flash.now[:danger] = "Incorrect code, please try again"
      render :two_factor
    end
  end

  def resend
    @user = User.find(session[:pre_2fa_auth_user_id])
    Authy::API.request_sms(id: @user.authy_id)
    flash[:notice] = "Verification code re-sent"
    redirect_to sessions_two_factor_path
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You have been logged out"
    redirect_to root_path
  end
end
