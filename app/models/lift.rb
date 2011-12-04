class Lift < ActiveRecord::Base
  belongs_to :station
  belongs_to :manufacturer
  belongs_to :operator
  has_many :events  

  acts_as_api

  api_accessible :lift_template do |template|
    template.add :id
    template.add :operator, :template => :simple
    template.add :station, :template => :simple
    template.add :manufacturer, :template => :manufacturer_template
    template.add :description
    template.add :events, :template => :event_template
  end


end
