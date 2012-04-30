class AddExternalIdToLinesStations < ActiveRecord::Migration
  def change
    add_column :lines_stations, :external_id, :integer
  end
end
