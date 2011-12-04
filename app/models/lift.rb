class Lift < ActiveRecord::Base
  belongs_to :station
  belongs_to :manufacturer
  belongs_to :operator
  has_many :events, :order => 'timestamp DESC'

  acts_as_api do |config|
    config.allow_jsonp_callback = true
  end

  acts_as_api

  api_accessible :default do |template|
    template.add :id
    template.add :operator
    template.add :station
    template.add :manufacturer
    template.add :description
    template.add :events
    template.add :timestamp
  end

  api_accessible :simple do |template|
    template.add :id
    template.add :description
    template.add :station, :template => :default
  end

  api_accessible :broken do |template|
    template.add :id
    template.add :description
    template.add :station_id
    template.add :last_event, :template => :default do
      template.add :timestamp
    end
  end

  def broken?
    last_event.broken? rescue false
  end

  def last_event
    events.first
  end

  def timestamp
    self.created_at.to_i
  end

  def self.broken
    coll = []
    Lift.find_each do |lift|
      coll << lift if lift.broken?
    end
    coll
  end

end
