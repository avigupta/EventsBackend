class Event < ActiveRecord::Base
	validates :name, presence: true

	belongs_to :user
	has_many :invitees, :dependent => :destroy
	has_one :event_image, :dependent => :destroy
end
