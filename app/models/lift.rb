class Lift < ActiveRecord::Base
  has_many :lift_stations
  belongs_to :manufacturer

  acts_as_api

  api_accessible :simple do |template|
    template.add :id
    template.add :name
  end


end
