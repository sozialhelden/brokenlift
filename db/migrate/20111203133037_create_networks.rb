class CreateNetworks < ActiveRecord::Migration
  def change
    create_table :networks do |t|
      t.string :name
      t.integer :operator_id

      t.timestamps
    end
  end
end
