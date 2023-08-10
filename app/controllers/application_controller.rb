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

  GUEST_USER_EMAIL_REGEX = /@example\.com$/

  def check_guest_user_edit
    if current_user.email =~ GUEST_USER_EMAIL_REGEX
      flash[:warning] = "ゲストユーザーは編集できません"
      redirect_to root_path
    end
  end

  def check_guest_user_destroy
    if current_user.email =~ GUEST_USER_EMAIL_REGEX
      current_user.destroy
      flash[:notice] = "ゲストユーザー情報が削除されました"
      redirect_to root_path, status: :see_other
    end
  end
end
