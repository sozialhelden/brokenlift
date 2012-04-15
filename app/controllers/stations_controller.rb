class StationsController < ApplicationController
  def index
    @stations = Station.find(:all)
    @lifts_broken = 0
    @lifts_sbahn = 0
    @lifts_bvg = 0
    
    @stations.each do |station|
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
  end
  
  def show
    @station = Station.find(params[:id])    
  end
end
