class ProfilesController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :withdrawal]
  before_action :edit_user_session_clear, except: [:edit]
  before_action :new_walking_route_session_clear
  before_action :edit_walking_route_session_clear

  def show
    if @user = User.find_by(id: params[:id])
      @bookmarks = @user.bookmarks.includes([:user, walking_route: :user])
      @walking_routes = @user.walking_routes
    else
      flash[:info] = ["退会済みのユーザーです"]
      redirect_to root_path
    end
  end

  def edit
    @user = session[:edit_user].present? ? User.new(session[:edit_user]) : User.find(current_user.id)
  end

  def update
    @user = current_user
    if @user.update(user_params)
      flash[:info] = ["プロフィール情報の更新が完了しました"]
      redirect_to action: :show
    else
      session[:edit_user] = @user
      flash[:warning] = @user.errors.full_messages
      redirect_to action: :edit
    end
  end

  def withdrawal
    @user = current_user
    @user.update(is_deleted: true)
    reset_session
    flash[:notice] = "退会処理が完了しました"
    redirect_to root_path
  end

  private

  def user_params
    # form_withのurlオプションを使うため、requireは設定なし
    params.permit(:name, :comment, :profile_image, :remove_profile_image)
  end
end
