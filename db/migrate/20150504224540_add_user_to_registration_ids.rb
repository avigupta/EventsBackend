class AddUserToRegistrationIds < ActiveRecord::Migration
  def change
    add_reference :registration_ids, :user, index: true, foreign_key: true
  end
end
