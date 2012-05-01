class StationsController < ApplicationController
  def index
    @page = params[:page] || 1
    @stations_broken = Station.with_lifts.broken.uniq
    @stations = (Station.with_lifts - @stations_broken).uniq
    @lifts_broken = Lift.broken.uniq.count
    @lifts_sbahn = Network.find_by_name('S-Bahn').lifts.broken.uniq.count
    @lifts_bvg = Network.find_by_name('BVG').lifts.broken.uniq.count

  end

  def show
    @station = Station.find(params[:id])
  end

end
