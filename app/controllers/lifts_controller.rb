class LiftsController < ApiController

  respond_to :xml, :json

  actions :index, :show

  def index
    @lifts = Lift.paginate(:page => params[:page], :per_page => 50)
    index! do |format|
      format.xml      {render_for_api :lift_template, :xml  => @lifts, :root => :lifts}
      format.json     {render_for_api :lift_template, :json => @lifts, :root => :lifts}
    end
  end

  def show
    @lift = Lift.find(params[:id])
    show! do |format|
      format.xml      {render_for_api :lift_template, :xml  => @lift, :root => :lift}
      format.json     {render_for_api :lift_template, :json => @lift, :root => :lift}
    end
  end

end