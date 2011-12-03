class LiftsController < Api::ApiController

  actions :index, :show

  def index
    index! do |format|
      format.xml      {render_for_api :simple, :xml  => @lifts, :root => :lifts}
      format.json     {render_for_api :simple, :json => @lifts, :root => :lifts}
    end
  end

  def show
    show! do |format|
      format.xml      {render_for_api :simple, :xml  => @lift, :root => :lift}
      format.json     {render_for_api :simple, :json => @lift, :root => :lift}
    end
  end


end