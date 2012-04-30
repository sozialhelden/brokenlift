class Station < ActiveRecord::Base
  belongs_to :location
  has_many :lifts, :dependent => :destroy
  has_many :lines_stations
  has_many :lines, :through => :lines_stations

  scope :with_lifts, :include => :lifts

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

  # This merges the lifts and lines of THIS station
  # into another station and then deletes itself.
  def merge_into(another_station)
    self.lifts.each do |lift|
      lift.station = another_station
      lift.save!
    end

    self.lines_stations.each do |line_station|
      line_station.station_id = another_station.id
      line_station.save!
    end

    another_station.location = self.location if self.location
    self.delete
  end

  def lifts_total
    lifts.count
  end

  def lifts_working
    lifts.working.count
  end

  def lifts_broken
    lifts.broken.count
  end

  def broken?
    lifts_broken > 0
  end

  def self.broken
    Lift.broken.map(&:station)
  end

  def self.working
    Lift.working.map(&:station)
  end

end