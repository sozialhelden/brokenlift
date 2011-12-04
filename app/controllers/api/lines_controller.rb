class Api::LinesController < Api::ApiController
  respond_to :xml, :json

  actions :index, :show

  def index
    index! do |format|
      format.xml      {render_for_api :default, :xml  => @lines, :root => :lines}
      format.json     {render_for_api :default, :json => @lines, :root => :lines}
    end
  end

  def show
    show! do |format|
      format.xml      {render_for_api :default, :xml  => @line, :root => :line}
      format.json     {render_for_api :default, :json => @line, :root => :line}
    end
  end

  def resource
    @line ||= Line.find(params[:id])
  end

  def collection
    @lines ||= Line.page(params[:page] || 1).per(50)
  end


end