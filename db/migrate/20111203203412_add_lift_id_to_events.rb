class AddLiftIdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :lift_id, :integer
  end
end
