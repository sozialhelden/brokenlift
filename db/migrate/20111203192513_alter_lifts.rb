class AlterLifts < ActiveRecord::Migration
  def change
    change_table :lifts do |t|
        t.remove :name
        t.remove :status
        t.integer :station_id
    end
  end
end
