class ApplicationController < ActionController::Base
  protect_from_forgery


  private
  def require_login
    redirect_to(root_path) unless signed_in?
    false
  end
end
