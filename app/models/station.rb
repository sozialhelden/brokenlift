class Station < ActiveRecord::Base
  belongs_to :location
  has_many :lifts
  has_many :lines_stations
  has_many :lines, :through => :lines_stations

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
  
  def lifts_broken
    lifts.reject{|l| !l.broken?}.size
  end
  
  def broken?
    station.lifts_working != station.lifts_total rescue false
  end

end