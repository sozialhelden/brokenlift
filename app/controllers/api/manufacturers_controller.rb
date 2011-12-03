class Api::ManufacturersController < Api::ApiController

  respond_to :xml, :json

  actions :index, :show

  def index
    index! do |format|
      format.xml      {render_for_api :manufacturer_template, :xml  => @manufacturers, :root => :manufacturers}
      format.json     {render_for_api :manufacturer_template, :json => @manufacturers, :root => :manufacturers}
    end
  end

  def show
    show! do |format|
      format.xml      {render_for_api :manufacturer_template, :xml  => @manufacturer, :root => :manufacturer}
      format.json     {render_for_api :manufacturer_template, :json => @manufacturer, :root => :manufacturer}
    end
  end

  def resource
    @manufacturer ||= Manufacturer.find(params[:id])
  end

  def collection
    @manufacturers ||= Manufacturer.page(params[:page] || 1).per(50)
  end




end

