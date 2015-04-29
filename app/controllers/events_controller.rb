class EventsController < ApplicationController
	require 'gcm'
	API_KEY = "AIzaSyBFn_H4dERP9vPqyPBtpFhseCB79dwodfA"

	before_action :authenticate_user

	def create
		event = Event.new
		event.name = params[:name]
		event.location = params[:location]
		event.description = params[:description]
		event.type = params[:type]
		event.startTime = params[:startTime]
		event.endTime =  params[:endTime]
		event.imageUrl = params[:imageUrl]
		event.publicEvent = params[:publicEvent]
		event.organization = params[:organization]

		if event.save
			respond_to do |format|
				format.html {render plain: "Event created. Id = #{event.id}", status: 200 }
				format.json {render json: { eventId: event.id, msg: "Event created" }, status: 200 }
			end
		elsif
			respond_to do |format|
				format.html {render plain: "Error in creating event", status: 400 }
				format.json {render json: { msg: "Error in creating event" }, status: 400 }
			end
		end
	end

	def save_image
		eventImage = EventImage.new(image_params)

		if eventImage.save
			puts eventImage.image.url
      		respond_to do |format|
				format.html {render plain: "Image received", status: 200 }
				format.json {render json: { eventId: params[:eventId], msg: "Image received" }, status: 200 }
			end
     	else
       		respond_to do |format|
				format.html {render plain: "Error saving image", status: 400 }
				format.json {render json: { eventId: params[:eventId], msg: "Error saving image" }, status: 400 }
			end
    	end
	end

	def info
		eventImage = ""
		if EventImage.find_by(eventId: params[:eventId])
			eventImage = EventImage.find_by(eventId: params[:eventId])
		end

		if Event.find(params[:eventId])
			event = Event.find(params[:eventId])
			respond_to do |format|
				format.html {render plain: event.id + " " + event.name, status: 200 }
				format.json {render json: { eventId: event.id, name: event.name, location: event.location, description: event.description,
					                        type: event.type, startTime: event.startTime, endTime: event.endTime, organization: event.organization,
					                        publicEvent: event.publicEvent, imageUrl: eventImage.image.url}, status: 200 }
			end
		else
			respond_to do |format|
				format.html {render plain: "Event not found", status: 400 }
				format.json {render json: { msg: "Event not found" }, status: 400 }
			end
		end
	end

	def respondToInvite
		if Invitee.where("event_id = ? AND email = ?", params[:eventId], params[:email]).blank?
			respond_to do |format|
				format.html {render plain: "Not invited to this event", status: 400}
				format.json {render json: {msg: "Not invited to this event"}, status: 400}
			end
		elsif
			invitation = Invitee.find_by(event_id: params[:eventId], email: params[:email])
			invitation.status = params[:status]
			invitation.save
			owner = Event.find_by(id: params[:eventId])
			notifyOnwer(params[:eventId], owner.email, params[:email], params[:status])
			respond_to do |format|
				format.html{render plain: "Notified to owner", status: 200}
				format.json{json json: {msg: "Notified to owner"}, status: 200}
			end
		end
	end
		

	def invite
		usersInvited = Array.new
		list = params[:list].split(",")
		eventId = params[:eventId]

		eventName = Event.find(params[:eventId]).name
		list.each do |x|
			if Invitee.where("event_id = ? AND email = ?", params[:eventId], x).blank?
				invitee = Invitee.new
				invitee.email = x
				invitee.event_id = params[:eventId]
				invitee.status = "invited"
				invitee.save
				usersInvited << x
			end
		end
		sendInviteNotification(usersInvited, eventName)
		sendInviteEmail(usersInvited)

		respond_to do |format|
			format.html {render plain: "Invited users", status: 200 }
			format.json {render json: { msg: usersInvited }, status: 200 }
		end
	end

	private
	def notifyOwner(eventId, ownerEmail, userEmail, response)
		gcm = GCM.new(API_KEY)
		if RegistrationId.find_by(email: ownerEmail)
			rOwner = RegistrationId.find_by(email: ownerEmail)
			options = {data: {type: 2, eventId: eventId, email: userEmail, response: response}, collapse_key: "update_score"}
			response = gcm.send(rOwner.regid, options)
		end
	end


	def sendInviteNotification(users, eName)
		gcm = GCM.new(API_KEY)
		reg_ids = Array.new
		users.each do |x|
			if RegistrationId.find_by(email: x)
				rUser = RegistrationId.find_by(email: x)
				reg_ids << rUser.regid
			end
		end
		options = {data: {type: 1, eventId: params[:eventId], eventName: eName, email: params[:email]}, collapse_key: "updated_score"}
		response = gcm.send(reg_ids, options)
	end

	def sendInviteEmail(users)
		users.each do |x|
			if not RegistrationId.find_by(email: x)
				#TODO: send email to the user
			end
		end
	end


	def authenticate_user
		if !User.find_by(email: params[:email])
			respond_to do |format|
				format.html {render plain: "User doesn't exists" }
				format.json {render json: { msg: "User doesn't exists" }, status: 400 }
			end
		end
	end

	def image_params
    	params.permit(:image, :eventId)
	end
end
