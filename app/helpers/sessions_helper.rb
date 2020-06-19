module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def remember(user)
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent.encrypted[:remember_token] = user.remember_token
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def current_user
    if session[:user_id]
      user = User.find_by(id: session[:user_id])
      @current_user ||= user if session[:session_token] == user.session_token
    elsif (user = User.find_by(id: cookies.encrypted[:user_id]))
      if user.authenticated?(cookies.encrypted[:remember_token])
        log_in user
        @current_user ||= user
      end
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    forget(current_user)
    reset_session
    @current_user = nil
  end

  def current_user?(user)
    user && user == current_user
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
