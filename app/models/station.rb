class Station < ActiveRecord::Base
  has_many :lifts
  has_one :location
  has_many :station_lines
  has_many :lines, :through => :station_lines

  acts_as_api

  api_accessible :simple do |template|
    template.add :id
    template.add :name
    template.add :osm_id
  end

end

