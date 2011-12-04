class Api::ManufacturersController < Api::ApiController

  respond_to :xml, :json

  actions :index, :show

  def index
    index! do |format|
      format.xml      {render_for_api :default, :xml  => @manufacturers, :root => :manufacturers}
      format.json     {render_for_api :default, :json => @manufacturers, :root => :manufacturers}
    end
  end

  def show
    show! do |format|
      format.xml      {render_for_api :default, :xml  => @manufacturer, :root => :manufacturer}
      format.json     {render_for_api :default, :json => @manufacturer, :root => :manufacturer}
    end
  end

  def resource
    @manufacturer ||= Manufacturer.find(params[:id])
  end

  def collection
    @manufacturers ||= Manufacturer.page(params[:page] || 1).per(50)
  end




end

