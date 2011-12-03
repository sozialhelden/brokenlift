class Line < ActiveRecord::Base
  belongs_to :network # foreign key - network_id
  has_and_belongs_to_many :stations
  
  acts_as_api

  api_accessible :simple do |template|
    template.add :id
    template.add :name
    template.add :network_id
  end
end

