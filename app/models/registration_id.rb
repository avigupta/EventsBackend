class RegistrationId < ActiveRecord::Base
	validates :email, presence: true
	validates :regid, presence: true
end
