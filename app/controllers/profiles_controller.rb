class ProfilesController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :withdrawal]

  def show
    @user = User.find(params[:id])
    @bookmarks = Bookmark.where(user_id: @user.id)
  end

  def edit
    @user = session[:user].present? ? User.new(session[:user]) : User.find(current_user.id)
  end

  def update
    @user = current_user
    if @user.update(user_params)
      session[:user].clear if session[:user]
      flash[:info] = ["プロフィール情報の更新が完了しました"]
      redirect_to  action: :show
    else
      session[:user] = @user
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
