class Api::StationsController < Api::ApiController

  respond_to :xml, :json

  belongs_to :line, :optional => true

  actions :index, :show

  def index
    index! do |format|
      format.xml      {render_for_api :default, :xml  => @stations, :root => :stations}
      format.json     {render_for_api :default, :json => @stations, :root => :stations}
    end
  end

  def show
    show! do |format|
      format.xml      {render_for_api :default, :xml  => @station, :root => :station}
      format.json     {render_for_api :default, :json => @station, :root => :station}
    end
  end

  def collection
    @stations ||= end_of_association_chain.page(params[:page] || 1).per(50)
  end

  def resource_class
    Station
  end
end

