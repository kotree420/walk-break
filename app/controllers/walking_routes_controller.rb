class WalkingRoutesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :edit_user_session_clear
  before_action :new_walking_route_session_clear, except: [:new]
  before_action :edit_walking_route_session_clear, except: [:edit]

  def index
  end

  def show
    @walking_route = WalkingRoute.find(params[:id])
    if @user = @walking_route.user
      @bookmarks_count = @walking_route.bookmarks_count
    else
      flash[:info] = ["退会済みのユーザーです"]
      redirect_to root_path
    end
  end

  def new
    @walking_route = WalkingRoute.new(session[:new_walking_route] || {})
    @user = current_user
  end

  def create
    @walking_route = WalkingRoute.new(walking_route_params)
    if @walking_route.save
      flash[:info] = ["ルート作成が完了しました"]
      redirect_to action: :show, id: @walking_route.id
    else
      session[:new_walking_route] = @walking_route
      flash[:warning] = @walking_route.errors.full_messages
      redirect_to action: :new
    end
  end

  def edit
    @user = current_user
    @walking_route = session[:walking_route_edit].present? ? WalkingRoute.new(session[:walking_route_edit]) : WalkingRoute.find(params[:id])
  end

  def update
    @walking_route = WalkingRoute.find(params[:id])
    if @walking_route.update(walking_route_update_params)
      flash[:info] = ["散歩ルート情報の更新が完了しました"]
      redirect_to action: :show
    else
      session[:walking_route_edit] = @walking_route
      flash[:warning] = @walking_route.errors.full_messages
      redirect_to action: :edit
    end
  end

  def destroy
  end

  private

  def walking_route_params
    params
      .require(:walking_route)
      .permit(:name, :comment, :distance, :duration,
        :start_address, :end_address, :encorded_path, :user_id)
  end

  def walking_route_update_params
    params
      .permit(:name, :comment, :distance, :duration,
        :start_address, :end_address, :encorded_path, :user_id)
  end
end
