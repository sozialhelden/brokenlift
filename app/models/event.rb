class Event < ActiveRecord::Base
  belongs_to :event_type
  
  acts_as_api

  api_accessible :event_template do |template|
    template.add :timestamp
    template.add :event_type_id
  end
end