class Event < ActiveRecord::Base
  belongs_to :event_type
  belongs_to :lift

  attr :duration, true

  scope :last_events, :joins => :event_type, :limit => 1, :order => 'events.timestamp DESC'
  scope :for_days, lambda {|days| { :conditions => ['events.timestamp > ?', days.days.ago ] } }
  scope :with_event_type, :include => :event_type
  scope :last_event_per_lift, :select => 'distinct events.id, events.lift_id, events.timestamp',
    :group => 'lift_id, events.id, events.timestamp',
    :having => 'max(timestamp) = events.timestamp'

    # This selects all events, which have been changed depending on the event before.
    # see http://www.artfulsoftware.com/infotree/queries.php#820
    #
    # SELECT a.timestamp, a.event_type_id
    # FROM (
    #   SELECT t1.*, COUNT(*) AS rank
    #   FROM events t1
    #   LEFT JOIN events t2 ON t1.timestamp >= t2.timestamp
    #   WHERE t1.lift_id = 4
    #   GROUP BY t1.timestamp
    # ) AS a
    # LEFT JOIN (
    #   SELECT t1.*, COUNT(*) AS rank
    #   FROM events t1
    #   LEFT JOIN events t2 ON t1.timestamp >= t2.timestamp
    #   WHERE t1.lift_id = 4
    #   GROUP BY t1.timestamp
    # ) AS b ON a.rank = b.rank+1 AND a.event_type_id = b.event_type_id
    # WHERE b.timestamp IS NULL
    # ORDER BY a.timestamp;

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

  def self.prune
    self.find_each(:batch_size => 1) do |e|
      Event.transaction do
        events_to_delete = Event.where(['id <> ? AND lift_id = ? AND event_type_id = ? AND timestamp = ?', e.id, e.lift_id, e.event_type_id, e.timestamp ])
        events_to_delete.map(&:delete)
      end
    end
  end
end

