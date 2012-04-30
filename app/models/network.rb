class Network < ActiveRecord::Base
  belongs_to :operator
  has_many :lines
  has_many :stations, :through => :lines, :dependent => :destroy
  has_many :lifts, :through => :stations

end

