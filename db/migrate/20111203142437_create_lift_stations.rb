class CreateLiftStations < ActiveRecord::Migration
  def change
    create_table :lift_stations do |t|
      t.integer :lift_id
      t.integer :station_id

      t.timestamps
    end
  end
end
