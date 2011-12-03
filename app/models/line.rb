class Line < ActiveRecord::Base
  belongs_to :network # foreign key - network_id
  has_many :stations
end

