class RegistrationId < ActiveRecord::Base
	belongs_to :user

	validates :email, presence: true
	validates :regid, presence: true
end
