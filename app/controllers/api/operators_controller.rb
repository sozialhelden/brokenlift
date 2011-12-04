class Api::OperatorsController < Api::ApiController

  respond_to :xml, :json

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

  def resource
    @operator ||= Operator.find(params[:id])
  end

  def collection
    @operators ||= Operator.page(params[:page] || 1).per(50)
  end




end

