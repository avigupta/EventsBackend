class GalaMailer < ApplicationMailer
	def invite_email(users, event)
		users.each do |x|
			@user = x
			@event = event
			mail(from: @event.user.email, to: @user, subject: 'Invitation to ' + @event.name)
		end
	end
end
