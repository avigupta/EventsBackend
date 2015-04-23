class RegistrationId < ActiveRecord::Base
	validates :email, presence: true
	validates :password, presence: true
end
