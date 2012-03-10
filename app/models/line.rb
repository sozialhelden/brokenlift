class Line < ActiveRecord::Base
  belongs_to :network # foreign key - network_id
  has_many :lines_stations
  has_many :stations, :through => :lines_stations

  acts_as_api

  api_accessible :default do |template|
    template.add :id
    template.add :name
    template.add "network.operator", :as => :operator
  end
end

