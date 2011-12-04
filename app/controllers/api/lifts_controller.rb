class Api::LiftsController < Api::ApiController

  respond_to :xml, :json

  belongs_to :station, :optional => true

  actions :index, :show

  custom_actions :resource => :get, :collection => :broken

  def index
    index! do |format|
      format.xml      {render_for_api :default, :xml  => @lifts, :root => :lifts}
      format.json     {render_for_api :default, :json => @lifts, :root => :lifts}
    end
  end

  def show
    show! do |format|
      format.xml      {render_for_api :default, :xml  => @lift, :root => :lift}
      format.json     {render_for_api :default, :json => @lift, :root => :lift}
    end
  end

  def broken
    @lifts = Lift.broken
    respond_to do |format|
      format.xml      {render_for_api :broken, :xml  => @lifts, :root => :lifts}
      format.json     {render_for_api :broken, :json => @lifts, :root => :lifts}
    end
  end

  def collection
    @lifts ||= end_of_association_chain.page(params[:page] || 1).per(500)
  end

  def resource_class
    Lift
  end
end