class Operator < ActiveRecord::Base
  has_many :networks
  
  acts_as_api

  api_accessible :default do |template|
    template.add :id
    template.add :name
  end
end

