class Event < ActiveRecord::Base
  belongs_to :event_type
  belongs_to :lift

  acts_as_api

  api_accessible :default do |template|
    template.add :id
    template.add :timestamp
    template.add :is_working
    template.add :description
  end


  api_accessible :extended do |template|
    template.add :id
    template.add :timestamp
    template.add :is_working
    template.add :description
    template.add :lift, :template => :simple
  end

  scope :last_events, :joins => :event_type, :limit => 1, :order => 'events.timestamp DESC'
  scope :last_event_per_lift, :select => 'distinct events.id, events.lift_id, events.timestamp',
                              :group => 'lift_id, events.id, events.timestamp',
                              :having => 'max(timestamp) = events.timestamp'

  def broken?
    event_type.is_working == false
  end

  def is_working
    !broken?
  end

  def description
    event_type.name
  end
end
