class CreateLines < ActiveRecord::Migration
  def change
    create_table :lines do |t|
      t.string :name
      t.integer :network_id

      t.timestamps
    end
  end
end
