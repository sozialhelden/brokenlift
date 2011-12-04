class Location < ActiveRecord::Base

  acts_as_api

  api_accessible :simple do |template|
    template.add :id
    template.add :longitude
    template.add :latitude
  end


end

