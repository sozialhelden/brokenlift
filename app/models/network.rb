class Network < ActiveRecord::Base
  belongs_to :operator # foreign key - operator_id
  has_many :lines
  has_many :stations, :through => :lines
  has_many :lifts, :through => :stations
end

