class AddOperatorIdToLifts < ActiveRecord::Migration
  def change
    add_column :lifts, :operator_id, :integer
  end
end
