class Lift < ActiveRecord::Base
  belongs_to :station
  belongs_to :manufacturer
  belongs_to :operator
  has_many :events 
  
  acts_as_api do |config|
    config.allow_jsonp_callback = true
  end

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
end
