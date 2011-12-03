class LiftStation < ActiveRecord::Base
  belongs_to :lift
  belongs_to :station
end
