class Lift < ActiveRecord::Base
  has_many :lift_stations
  belongs_to :manufacturer
end
