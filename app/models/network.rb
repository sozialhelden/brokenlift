class Network < ActiveRecord::Base
  belongs_to :operator # foreign key - operator_id
  has_many :lines
end

