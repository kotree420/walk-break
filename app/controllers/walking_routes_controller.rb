class WalkingRoutesController < ApplicationController
  before_action :authenticate_user!, only: [:new]

  def index
  end

  def show
    @walking_route = WalkingRoute.find(params[:id])
    @user = @walking_route.user
  end

  def new
    @walking_route = WalkingRoute.new(session[:walking_route] || {})
    @user = current_user
  end

  def create
    @walking_route = WalkingRoute.new(walking_route_params)
    if @walking_route.save
      session[:walking_route].clear if session[:walking_route]
      flash[:info] = ["ルート作成が完了しました"]
      redirect_to action: :show, id: @walking_route.id
    else
      session[:walking_route] = @walking_route
      flash[:warning] = @walking_route.errors.full_messages
      redirect_to action: :new
    end
  end

  private

  def walking_route_params
    params.require(:walking_route).
      permit(:name, :comment, :distance, :duration, :start_address, :end_address, :encorded_path, :user_id)
  end
end
