class StationsController < ApplicationController
  def index
    redirect_to root_path
  end
  
  def show
    @station = Station.find(params[:id])    
  end
end
