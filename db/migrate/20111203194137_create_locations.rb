class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
        t.float :longitude
        t.float :latitude
    end
  end
end
