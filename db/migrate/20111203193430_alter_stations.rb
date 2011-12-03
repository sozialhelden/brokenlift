class AlterStations < ActiveRecord::Migration
  def change
    change_table :stations do |t|
        t.remove :line_id
        t.integer :location_id
        t.string :osm_id        
    end
  end
end
