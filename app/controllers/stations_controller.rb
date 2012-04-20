class StationsController < ApplicationController
  def index
    @stations = Station.find(:all)
    @stations_broken = []
    @lifts_broken = 0
    @lifts_sbahn = 0
    @lifts_bvg = 0
    
    @stations.each_with_index do |station, index|
      if station.broken?
          @stations_broken.push(station)
      end
      @lifts_broken += station.lifts_broken
      
      station.lifts.each do |lift|
        unless lift.broken?
          next
        end
        
        if lift.operator.name == "BVG"
          @lifts_bvg += 1
        end
        if lift.operator.name == "S-Bahn"
          @lifts_sbahn += 1
        end
      end
    end
    
    # @todo put the deletion of stations also in loop above
    @stations_broken.each do |station|
      @stations.delete(station)
    end
  end
  
  def show
    @station = Station.find(params[:id])    
  end
end
