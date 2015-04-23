class CreateRegistrationIds < ActiveRecord::Migration
  def change
    create_table :registration_ids do |t|
      t.string :email
      t.string :regid

      t.timestamps null: false
    end
  end
end
