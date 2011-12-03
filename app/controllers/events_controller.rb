class EventsController < ApiController

  #todo create inverse logic
  actions :index, :show

  def index  
    index! do |format|
      format.xml      {render_for_api :event_template, :xml  => @events, :root => :events}
      format.json     {render_for_api :event_template, :json => @events, :root => :events}
    end
  end

  def show
    show! do |format|
      format.xml      {render_for_api :event_template, :xml  => @event, :root => :event}
      format.json     {render_for_api :event_template, :json => @event, :root => :event}
    end
  end


end