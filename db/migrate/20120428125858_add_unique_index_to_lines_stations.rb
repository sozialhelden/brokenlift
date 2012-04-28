class AddUniqueIndexToLinesStations < ActiveRecord::Migration
  def up
    add_index :lines_stations, [:line_id, :station_id], :unique => true
  end

  def down
    remove_index :lines_stations, [:line_id, :station_id]
  end
end
