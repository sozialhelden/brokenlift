class Api::OperatorsController < Api::ApiController

  respond_to :xml, :json
  
  belongs_to :lift, :optional => true

  actions :index, :show

  def index
    index! do |format|
      format.xml      {render_for_api :default, :xml  => @operators, :root => :operators}
      format.json     {render_for_api :default, :json => @operators, :root => :operators}
    end
  end

  def show
    show! do |format|
      format.xml      {render_for_api :default, :xml  => @operator, :root => :operator}
      format.json     {render_for_api :default, :json => @operator, :root => :operator}
    end
  end

  def collection
    @operators ||= end_of_association_chain.page(params[:page] || 1).per(50)
  end




end

