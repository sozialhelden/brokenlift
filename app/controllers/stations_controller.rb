class StationsController < ApplicationController
  def index
    @page = params[:page] || 1
    @stations_broken = Station.with_lifts.broken
    @stations = Station.with_lifts - @stations_broken
    @lifts_broken = Lift.broken.count
    @lifts_sbahn = Network.find_by_name('S-Bahn').lifts.broken.count
    @lifts_bvg = Network.find_by_name('BVG').lifts.broken.count

  end

  def show
    @station = Station.find(params[:id])
  end
end
