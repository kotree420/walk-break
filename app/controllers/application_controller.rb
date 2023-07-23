class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email])
    # name,profile_imageはdevise外のprofilesコントローラーでupdateするためここでは記載なし
    devise_parameter_sanitizer.permit(:account_update, keys: [:email])
  end

  def edit_user_session_clear
    session[:edit_user].clear if session[:edit_user]
  end

  def new_walking_route_session_clear
    session[:new_walking_route].clear if session[:new_walking_route]
  end

  def edit_walking_route_session_clear
    session[:walking_route_edit].clear if session[:walking_route_edit]
  end
end
