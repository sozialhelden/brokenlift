class Lift < ActiveRecord::Base
  belongs_to :station
  belongs_to :manufacturer
  belongs_to :operator
  has_many :events, :order => 'timestamp DESC'
  has_many :lines, :through => :station

  acts_as_api do |config|
    config.allow_jsonp_callback = true
  end
  
  attr :downTime, true
  attr :downTimeEvents, true
  attr :dailyStatusHistory, true

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

  scope :inverse, lambda {|list_of_lift_ids| { :conditions => ["#{self.table_name}.id NOT IN (?)", list_of_lift_ids]}}

  # Acts as state machine? gem 'aasm'

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
  
  # @todo please refactor me
  def self.get_statistics(id, days)
    lift = self.find(id)    
    limit = Time.zone.now.advance(:days => -(days.to_i))
    events = lift.events.reverse
    sumDownTime = 0
    lift.downTimeEvents = Array.new
    dailyStatusHistory = Array.new
    
    for i in (1 .. days.to_i)
      date = Date.today.advance(:days => -i)
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
        
        for i in (0 .. durationInDays)
          date = event.timestamp.advance(:days => i).to_date
          dailyStatus = dailyStatusHistory.find{|dailyStatus| dailyStatus["date"] == date }
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

end
