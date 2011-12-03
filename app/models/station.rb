class Station < ActiveRecord::Base
  has_many :lift_stations
  has_many :lifts, :through => :lift_stations

end
