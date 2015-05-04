class RemoveEventIdFromEventImages < ActiveRecord::Migration
  def change
    remove_column :event_images, :eventId, :string
  end
end
