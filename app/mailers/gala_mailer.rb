class GalaMailer < ApplicationMailer
	def invite_email(users, event)
		users.each do |x|
			@user = x
			@event = event
			mail(from: @event.user.email, to: @user, subject: 'Invitation to ' + @event.name)
		end
	end

	def edit_email(users, event)
		users.each do |x|
			@user = x
			@event = event
			mail(from: @event.user.email, to: @user, subject: @event.name + " has been updated")
		end
	end

	def delete_email(users, event)
	end
end
