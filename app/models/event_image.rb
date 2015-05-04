class EventImage < ActiveRecord::Base	
	belongs_to :event

	has_attached_file :image,
					:storage => :dropbox,
					:dropbox_credentials => Rails.root.join("config/dropbox.yml"),
					#:dropbox_options => {...},
					#:path => ":events/:id_:filename",
					styles: {
					    thumb: '100x100>',
					    square: '200x200#',
					    medium: '300x300>'
					  }

	#validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
	#validates_attachment :image, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }
	do_not_validate_attachment_file_type :image
end
