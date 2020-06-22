class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by_email(params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      if @user.activated
        forwarding_url = session[:forwarding_url]
        reset_session
        log_in @user
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        session[:session_token] = @user.session_token

        redirect_to forwarding_url || @user
      else
        flash[:warning] = 'Account not activated.'
        redirect_to root_url
      end
    elsif
      flash.now[:danger] = 'Invalid user/password combination'

      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
