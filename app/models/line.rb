class Line < ActiveRecord::Base
  belongs_to :network # foreign key - network_id
  has_many :lines_stations
  has_many :stations, :through => :lines_stations
end

