class EventType < ActiveRecord::Base

  acts_as_api

  api_accessible :default do |template|
    template.add :name
    template.add :is_working
  end

  def self.broken
    @broken ||= EventType.where(:is_working => false).first
  end

  def self.working
    @broken ||= EventType.where(:is_working => true).first
  end

end

