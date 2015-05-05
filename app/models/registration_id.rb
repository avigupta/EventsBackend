class RegistrationId < ActiveRecord::Base
	belongs_to :user

	validates :regid, presence: true
end
