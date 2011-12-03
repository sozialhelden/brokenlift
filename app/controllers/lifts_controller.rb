class LiftsController < ApiController

  respond_to :xml, :json

  actions :index, :show

  def index
    index! do |format|
      format.xml      {render_for_api :lift_template, :xml  => @lifts, :root => :lifts}
      format.json     {render_for_api :lift_template, :json => @lifts, :root => :lifts}
    end
  end

  def show
    show! do |format|
      format.xml      {render_for_api :lift_template, :xml  => @lift, :root => :lift}
      format.json     {render_for_api :lift_template, :json => @lift, :root => :lift}
    end
  end

  def resource
    @lift ||= Lift.find(params[:id])
  end

  def collection
    @lifts ||= Lift.page(params[:page] || 1).per(50)
  end


end