class AlterEvents < ActiveRecord::Migration
  def up
    remove_column :events, :name
    add_column :events, :timestamp, :datetime
    add_column :events, :event_type_id, :integer
  end
  def down
    remove_column :events, :event_type_id
    remove_column :events, :timestamp
    add_column :events, :name, :string
  end
end

