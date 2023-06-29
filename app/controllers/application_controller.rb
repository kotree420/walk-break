class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up,keys:[:email])
      # name,profile_imageはdevise外のprofilesコントローラーでupdateするためここでは記載なし
      devise_parameter_sanitizer.permit(:account_update,keys:[:email])
    end
end
