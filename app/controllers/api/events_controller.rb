class Api::EventsController < Api::ApiController

  respond_to :xml, :json

  belongs_to :lift, :optional => true

  actions :index, :show

  def index

    index! do |format|
      if parent?
        format.xml      {render_for_api :default, :xml  => @events, :root => :events}
        format.json     {render_for_api :default, :json => @events, :root => :events}
      else
        format.xml      {render_for_api :extended, :xml  => @events, :root => :events}
        format.json     {render_for_api :extended, :json => @events, :root => :events}
      end
    end
  end

  def show

    show! do |format|
      format.xml      {render_for_api :extended, :xml  => @event, :root => :event}
      format.json     {render_for_api :extended, :json => @event, :root => :event}
    end
  end

  def collection
    @events ||= end_of_association_chain.page(params[:page] || 1).per(5000)
  end

  def resource_class
    Event
  end
end