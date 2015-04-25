class CreateEventImages < ActiveRecord::Migration
  def change
    create_table :event_images do |t|
      t.string :eventId

      t.timestamps null: false
    end
  end
end
