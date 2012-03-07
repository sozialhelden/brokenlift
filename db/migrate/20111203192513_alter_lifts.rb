class AlterLifts < ActiveRecord::Migration
  def up
    remove_column :lifts, :name
    remove_column :lifts, :status
    add_column :lifts, :station_id, :integer
  end
  def down
    remove_column :lifts, :station_id
    add_column :lifts, :status, :string
    add_column :lifts, :name, :string
  end
end

