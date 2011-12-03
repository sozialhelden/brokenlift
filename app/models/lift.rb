class Lift < ActiveRecord::Base
  belongs_to :station
  belongs_to :manufacturer
  has_many :events

  acts_as_api

  api_accessible :lift_template do |template|
    template.add :id
    template.add :manufacturer, :template => :manufacturer_template
    template.add :description
    template.add :events, :template => :event_template
    template.add :name
    template.add :station
  end


end

