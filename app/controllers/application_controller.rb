class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # super simple authentication: http://jrom.net/super-simple-authentication-in-rails
  helper_method :logged_in?

  def logged_in?
    session[:login]
  end

  def do_logout
    session[:login] = nil
    redirect_to '/'
  end

  private
  def authenticate
    login = authenticate_or_request_with_http_basic do |username, password|
      username == CREDENTIALS['username'] && Digest::SHA1.hexdigest(password) == CREDENTIALS['password']
    end
    session[:login] = login
  end

end
