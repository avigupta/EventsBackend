class RemoveImageUrlFromEvents < ActiveRecord::Migration
  def change
    remove_column :events, :imageUrl, :string
  end
end
