class Station < ActiveRecord::Base
  has_many :lifts
  has_one :location
  has_many :lines_stations
  has_many :lines, :through => :lines_stations

  acts_as_api

  api_accessible :simple do |template|
    template.add :id
    template.add :name
    template.add :osm_id
    template.add :lines, :template => :simple
  end

end

