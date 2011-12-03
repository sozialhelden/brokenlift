class AlterEvents < ActiveRecord::Migration
  def change
    change_table :events do |t|
        t.remove :name
        t.datetime :timestamp
        t.integer :event_type_id
    end
  end
end
