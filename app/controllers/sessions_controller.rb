class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      session[:pre_2fa_auth_user_id] = @user.id
      
      # Try to verify with OneTouch, will return response body
      one_touch = @user.send_one_touch

      # Respond to the ajax call that requested this 
      render json: one_touch
    else
      @user ||= User.new(email: params[:email])
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You have been logged out"
    redirect_to root_path
  end
end
