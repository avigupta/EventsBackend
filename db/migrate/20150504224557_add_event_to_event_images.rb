class AddEventToEventImages < ActiveRecord::Migration
  def change
    add_reference :event_images, :event, index: true, foreign_key: true
  end
end
