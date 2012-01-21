class DropLiftStations < ActiveRecord::Migration
  def up
    drop_table :lift_stations
  end

  def down
    create_table :lift_stations do |t|
        t.integer :lift_id
        t.integer :station_id
    end
  end
end

