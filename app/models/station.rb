class Station < ActiveRecord::Base
  belongs_to :line
  has_many :lift_stations

end
