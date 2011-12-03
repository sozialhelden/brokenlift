class CreateEventTypes < ActiveRecord::Migration
  def change
    create_table :event_types do |t|
        t.string :name
        t.boolean :is_working
    end
  end
end
