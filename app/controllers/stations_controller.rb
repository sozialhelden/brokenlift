class StationsController < ApiController

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


end

