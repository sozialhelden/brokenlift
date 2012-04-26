class AddIndexToEvents < ActiveRecord::Migration
  def up
    add_index :events, [:lift_id, :event_type_id, :timestamp]
  end

  def down
    remove_index :events, [:lift_id, :event_type_id, :timestamp]
  end
end
