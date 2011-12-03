class Location < ActiveRecord::Base
  belongs_to :station

  acts_as_api

  api_accessible :simple do |template|
    template.add :id
    template.add :longitude
    template.add :latitude
  end


end

