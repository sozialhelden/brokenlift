class Event < ActiveRecord::Base
  belongs_to :event_type
  belongs_to :lift

  acts_as_api

  api_accessible :default do |template|
    template.add :id
    template.add :timestamp
    template.add lambda{|event| event.event_type.is_working  }, :as => :is_working
    template.add lambda{|event| event.event_type.name  }, :as => :description
    template.add :lift_id
  end

  scope :last_events, :joins => :event_type, :limit => 1, :order => 'events.timestamp DESC'

  def broken?
    event_type.is_working == false
  end
end