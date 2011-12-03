class Line < ActiveRecord::Base
  belongs_to :network # foreign key - network_id
  has_many :station_lines
  has_many :stations, :through => :station_lines
end

