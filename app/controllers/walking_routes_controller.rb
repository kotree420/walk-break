class WalkingRoutesController < ApplicationController
  def index

  end

  def show
    @walking_route = WalkingRoute.find(params[:id])
  end

  def new
    @walking_route = WalkingRoute.new
  end

  def create
    @walking_route = WalkingRoute.new(walking_route_params)
    if @walking_route.save
      flash[:secondary] = "ルート作成が完了しました"
      redirect_to action: :show, id: @walking_route.id
    else
      render :new
    end
  end

  private
  def walking_route_params
    params.require(:walking_route).permit(:name, :comment, :distance, :duration, :start_address, :end_address, :encorded_path)
  end
end
