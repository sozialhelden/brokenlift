class CreateLifts < ActiveRecord::Migration
  def change
    create_table :lifts do |t|
      t.string  :name
      t.text    :description
      t.string  :status
      t.integer :manufacturer_id

      t.timestamps
    end
  end
end
