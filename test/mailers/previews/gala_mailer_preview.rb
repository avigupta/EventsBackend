# Preview all emails at http://localhost:3000/rails/mailers/gala_mailer
class GalaMailerPreview < ActionMailer::Preview
	def invite_email_preview
		GalaMailer.invite_email("avinaash.gupta50@gmail.com", Event.first)
  	end
end
