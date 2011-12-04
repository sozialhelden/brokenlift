class LiftsController < ApiController

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


end