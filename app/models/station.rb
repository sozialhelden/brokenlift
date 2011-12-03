class Station < ActiveRecord::Base
  has_many :lift_stations
  has_many :lifts, :through => :lift_stations
  has_one :location
  has_many :lines

  acts_as_api

  api_accessible :simple do |template|
    template.add :id
    template.add :name
    template.add :osm_id
  end

end

