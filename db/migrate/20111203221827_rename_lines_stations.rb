class RenameLinesStations < ActiveRecord::Migration
  def up
    rename_table :station_lines, :lines_stations
  end

  def down
    rename_table :lines_stations, :station_lines
  end
end

