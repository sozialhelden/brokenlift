class CreateOperators < ActiveRecord::Migration
  def change
    create_table :operators do |t|
      t.string :name

      t.timestamps
    end
  end
end
