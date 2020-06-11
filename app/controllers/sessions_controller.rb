class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      reset_session
      log_in user
      redirect_to user
    elsif
      flash.now[:danger] = 'Invalid user/password combination'

      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
