class Event < ActiveRecord::Base
  belongs_to :event_type
  belongs_to :lift
  
  acts_as_api

  api_accessible :event_template do |template|
    template.add :id
    template.add :timestamp
    template.add lambda{|event| event.event_type.is_working  }, :as => :is_working
    template.add lambda{|event| event.event_type.name  }, :as => :description
    template.add :lift_id
  end
end