class Manufacturer < ActiveRecord::Base
  has_many :lifts
  
  acts_as_api
  
  api_accessible :manufacturer_template do |template|
    template.add :id
    template.add :name
  end
end
