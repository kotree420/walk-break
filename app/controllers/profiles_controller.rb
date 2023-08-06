class ProfilesController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :withdrawal]
  before_action :edit_user_session_clear, except: [:edit]
  before_action :new_walking_route_session_clear
  before_action :edit_walking_route_session_clear

  def index
    @users = User.includes(:walking_routes, :bookmarked_walking_routes)
  end

  def search
    @keyword = search_params[:keyword]
    @users = User.search(@keyword)
    @search_results_count = @users.length
  end

  def show
    if @user = User.find_by(id: params[:id])
      @bookmarked_walking_routes = @user.bookmarked_walking_routes.includes(:user, bookmarks: :user)
      @walking_routes = @user.walking_routes.latest.includes(:user, bookmarks: :user)
    else
      flash[:info] = ["退会済みのユーザーです"]
      redirect_to root_path
    end
  end

  def edit
    if session[:edit_user].present?
      @user = User.new(session[:edit_user])
    else
      @user = User.find(current_user.id)
    end
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

  def search_params
    params.permit(:keyword)
  end
end
