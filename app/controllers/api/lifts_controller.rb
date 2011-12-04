class Api::LiftsController < Api::ApiController

  respond_to :xml, :json

  belongs_to :station, :optional => true

  actions :index, :show

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

  def resource
    @lift ||= Lift.find(params[:id])
  end

  def collection
    @lifts ||= Lift.page(params[:page] || 1).per(50)
  end


end