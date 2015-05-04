class RemoveEmailFromRegistrationIds < ActiveRecord::Migration
  def change
    remove_column :registration_ids, :email, :string
  end
end
