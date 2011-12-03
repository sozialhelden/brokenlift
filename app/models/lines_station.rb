class LinesStation < ActiveRecord::Base
  belongs_to :line # foreign-key station_id
  belongs_to :station # foreign-key line_id
end

