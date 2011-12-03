class Line < ActiveRecord::Base
  belongs_to :network
  has_many :stations
end
