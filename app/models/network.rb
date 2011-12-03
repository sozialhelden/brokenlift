class Network < ActiveRecord::Base
  belongs_to :operator
  has_many :lines
end
