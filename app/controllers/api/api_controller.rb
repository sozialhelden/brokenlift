class Api::ApiController < ApplicationController
  # Include Inherited Resources behaviour
  inherit_resources

  defaults :route_prefix => 'api'

  # If nothing is set, default to JSON
  before_filter :set_default_response_format

  protected

  def set_default_response_format
    request.format = nil if request.format.to_sym == :html
    request.format ||= :json if params[:format].blank?
  end

end