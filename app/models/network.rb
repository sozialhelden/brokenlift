class Network < ActiveRecord::Base
  belongs_to :operator
  has_many :lines
  has_many :stations, :through => :lines
  has_many :lifts, :through => :stations

end

