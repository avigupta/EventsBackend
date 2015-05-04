class User < ActiveRecord::Base
	has_many :events
	has_one :registration_id

	validates :email, presence: true
	validates :email, uniqueness: true
	validates :password, presence: true
end
