module Helpers
  def is_logged_in?
    !session[:user_id].nil?
  end

  def log_in_as(user, password: 'password', remember_me: 1)
    delete logout_path
    post login_path, params: { session: { email: user.email,
                                          password: user.password,
                                          remember_me: remember_me } }
  end
end
