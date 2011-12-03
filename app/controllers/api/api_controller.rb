class Api::ApiController < ApplicationController
  # Include Inherited Resources behaviour
  inherit_resources

  defaults :route_prefix => 'api'

end