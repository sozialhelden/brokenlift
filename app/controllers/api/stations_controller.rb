class Api::StationsController < Api::ApiController

  respond_to :xml, :json

  actions :index, :show

  def index
    index! do |format|
      format.xml      {render_for_api :simple, :xml  => @stations, :root => :stations}
      format.json     {render_for_api :simple, :json => @stations, :root => :stations}
    end
  end

  def show
    show! do |format|
      format.xml      {render_for_api :simple, :xml  => @station, :root => :station}
      format.json     {render_for_api :simple, :json => @station, :root => :station}
    end
  end

  def resource
    @station ||= Station.find(params[:id])
  end

  def collection
    @stations ||= Station.page(params[:page] || 1).per(50)
  end




end

