class Event < ActiveRecord::Base
  belongs_to :event_type
  belongs_to :lift

  attr :duration, true

  scope :last_events, :joins => :event_type, :limit => 1, :order => 'events.timestamp DESC'
  scope :last_event_per_lift, :select => 'distinct events.id, events.lift_id, events.timestamp',
    :group => 'lift_id, events.id, events.timestamp',
    :having => 'max(timestamp) = events.timestamp'

    # This selects all events, which have been changed depending on the event before.
    #
    # SELECT a.time, a.value
    # FROM (
    #   SELECT t1.*, COUNT(*) AS rank
    #   FROM changes t1
    #   LEFT JOIN changes t2 ON t1.time >= t2.time
    #   GROUP BY t1.time
    # ) AS a
    # LEFT JOIN (
    #   SELECT t1.*, COUNT(*) AS rank
    #   FROM changes t1
    #   LEFT JOIN changes t2 ON t1.time >= t2.time
    #   GROUP BY t1.time
    # ) AS b ON a.rank = b.rank+1 AND a.value = b.value
    # WHERE b.time IS NULL
    # ORDER BY a.time;

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

  api_accessible :statistics do |template|
    template.add :id
    template.add :timestamp
    template.add :is_working
    template.add :duration
  end

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

