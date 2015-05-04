class Event < ActiveRecord::Base
	validates :name, presence: true

	belongs_to :user
	has_many :invitees
	has_one :event_image
end
