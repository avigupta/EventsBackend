class EventImage < ActiveRecord::Base	
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

	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end
