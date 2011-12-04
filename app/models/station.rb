class Station < ActiveRecord::Base
  has_many :lifts
  belongs_to :location
  has_and_belongs_to_many :lines

  acts_as_api

  api_accessible :default do |template|
    template.add :id
    template.add :name
    template.add :location
    template.add :osm_id
    template.add :lines
  end

  api_accessible :status do |template|
    template.add :id
    template.add :name
    template.add :lifts_total
    template.add :lifts_working
  end

  def lifts_total
    lifts.count
  end

  def lifts_working
    lifts.reject{|l| l.broken?}.size
  end

end

