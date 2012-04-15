class StationsController < ApplicationController
  def index
    @stations = Station.find(:all)
    puts @stations
  end
  
  def show
    @station = Station.find(params[:id])    
  end
end
