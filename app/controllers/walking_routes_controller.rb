class WalkingRoutesController < ApplicationController
  def index

  end

  def new
    @walking_route = WalkingRoute.new
  end
end
