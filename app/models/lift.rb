class Lift < ActiveRecord::Base
  belongs_to :station
  belongs_to :manufacturer
  belongs_to :operator
  has_many :events, :order => 'timestamp DESC', :dependent => :destroy
  has_many :lines, :through => :station

  attr :downTime, true
  attr :downTimeEvents, true
  attr :dailyStatusHistory, true

  acts_as_api

  acts_as_api do |config|
    config.allow_jsonp_callback = true
  end

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
    template.add :station, :template => :default
    template.add :operator, :template => :default
    template.add :lines, :template => :default
    template.add :last_event, :template => :default do
      template.add :timestamp
    end
  end

  api_accessible :statistics do |template|
    template.add :id
    template.add :downTime
    template.add :downTimeEvents
    template.add :dailyStatusHistory
  end

  scope :broken_selector, lambda { |broken_id| {
    :having => ['broken_id = ? ', broken_id ],
    :select => 'lifts.*, (SELECT events.event_type_id FROM events WHERE events.lift_id = lifts.id ORDER BY events.timestamp DESC LIMIT 1) as broken_id' } }
  scope :with_events, :include => :events
  scope :inverse, lambda {|list_of_lift_ids| { :conditions => ["#{self.table_name}.id NOT IN (?)", list_of_lift_ids]}}

  # Acts as state machine? gem 'aasm'

  def self.broken
    broken_type = EventType.broken
    scoped({}).broken_selector(broken_type).all
  end

  def self.working
    working_type = EventType.working
    scoped({}).broken_selector(working_type).all
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

  # @todo please refactor me
  def self.get_statistics(id, days)
    lift = self.find(id)
    days = days.to_i
    limit = Time.zone.now.advance(:days => -(days)) # days.days.ago
    events = lift.events.for_days(days).with_event_type.reverse
    sumDownTime = 0
    lift.downTimeEvents = Array.new
    dailyStatusHistory = Array.new

    for i in (0 .. days)
      date = Date.today.advance(:days => -i) # i.days.ago
      dailyStatus = Hash.new
      dailyStatus["date"] = date
      dailyStatus["is_working"] = true
      dailyStatusHistory.push(dailyStatus);
    end

    for i in (0 .. events.length - 1)
      event = events[i]
      event_next = events[i + 1]

      if event.timestamp.to_time < limit
        if ! event_next.nil? && event_next.timestamp.to_time >= limit
          event.timestamp = limit
        else
          next
        end
      end

      unless event_next.nil?
        event.duration = event_next.timestamp - event.timestamp
      else
        event.duration = Time.zone.now - event.timestamp.to_time
      end

      unless event.is_working
        durationInDays = (event.duration / 86400).round
        if durationInDays > days
          durationInDays = days
        end

        tomorrow = Time.zone.today.advance(:days => 1) # Date.tomorrow || 1.day.from_now
        for i in (0 .. durationInDays)
          date = event.timestamp.advance(:days => i).to_date
          if date >= tomorrow
            next
          end
          dailyStatus = dailyStatusHistory.find{|dailyStatus| dailyStatus["date"] == date }
          if dailyStatus == nil
            next
          end
          dailyStatus["is_working"] = false
        end

        sumDownTime += event.duration
        lift.downTimeEvents.push(event)
      end

    end

    lift.downTime = sumDownTime
    lift.dailyStatusHistory = dailyStatusHistory
    lift
  end

  # This will walk through all events by timestamp
  # and will delete those of them, which
  # have a predecessor and successor of the same type
  #
  # B W W W W B B W W B B B
  # 0 0 1 1 0 0 0 0 0 0 1 0
  # Meaning it will delete those events which are marked with a 1
  #
  def prune_events
    queue = Array.new(3)
    events_to_delete = []
    self.events.order('timestamp ASC').each do |e|
      queue.shift
      queue.push(e)
      next if queue.compact.size != 3
      event_type_id = e.event_type_id
      events_to_delete << e.id if queue.all?{|e| e.event_type_id == event_type_id}

      if events_to_delete.size >= 100
        Event.transaction do
          events_to_delete.each do |e|
            Event.delete(e)
          end
        end
        events_to_delete.clear
      end
    end

    Event.transaction do
      events_to_delete.each do |e|
        Event.delete(e)
      end
      events_to_delete.clear
    end
    true
  end


end

