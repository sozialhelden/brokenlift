class Lift < ActiveRecord::Base
  belongs_to :station
  belongs_to :manufacturer
  belongs_to :operator
  has_many :events

  acts_as_api do |config|
    config.allow_jsonp_callback = true
  end

  acts_as_api

  api_accessible :lift_template do |template|
    template.add :id
    template.add :operator, :template => :simple
    template.add :station, :template => :simple
    template.add :manufacturer, :template => :manufacturer_template
    template.add :description
    template.add :events, :template => :event_template
    template.add :timestamp
  end

  api_accessible :simple do |template|
    template.add :id
    template.add :description
    template.add :station
  end

  def broken?
    !last_event.try(:broken?).nil?
  end

  def last_event
    events.last_events.first
  end

  def timestamp
    self.created_at.to_i
  end

end
