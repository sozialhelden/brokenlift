class Station < ActiveRecord::Base
  has_many :lifts
  belongs_to :location
  has_and_belongs_to_many :lines

  acts_as_api

  api_accessible :simple do |template|
    template.add :id
    template.add :name
    template.add :lines
    template.add :location
    template.add :osm_id
    template.add :lines, :template => :simple
  end

end

