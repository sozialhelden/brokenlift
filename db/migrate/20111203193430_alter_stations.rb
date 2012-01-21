class AlterStations < ActiveRecord::Migration
  def up
    remove_column :stations, :line_id
    add_column :stations, :location_id, :integer
    add_column :stations, :osm_id, :integer
  end
  def down
    add_column :stations, :line_id, :integer
    remove_column :stations, :location_id
    remove_column :stations, :osm_id
  end
end

