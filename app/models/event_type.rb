class EventType < ActiveRecord::Base
  
  acts_as_api
  
  api_accessible :default do |template|
    template.add :name
    template.add :is_working
  end
end
