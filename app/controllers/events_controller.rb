class EventsController < ApplicationController
	require 'gcm'
	API_KEY = "AIzaSyBFn_H4dERP9vPqyPBtpFhseCB79dwodfA"

	before_action :authenticate_user
	before_action :eventId_present, only: [:save_image, :info, :invite]

	def create
		event = Event.new
		event.name = params[:name]
		event.location = params[:location]
		event.description = params[:description]
		event.type = params[:type]
		event.startTime = params[:startTime]
		event.endTime =  params[:endTime]
		event.publicEvent = params[:publicEvent]
		event.organization = params[:organization]
		event.user = User.find_by(email: params[:email])
		if event.save
			respond_to do |format|
				format.html {render plain: "Event created. Id = #{event.id}", status: 200 }
				format.json {render json: { eventId: event.id, msg: "Event created" }, status: 200 }
			end
		elsif
			respond_to do |format|
				format.html {render plain: event.errors.messages, status: 400 }
				format.json {render json: { msg: event.errors.messages }, status: 400 }
			end
		end
	end

	def save_image
		event = Event.find(params[:eventId])
		if event.event_image.blank?
			event.build_event_image
		end
		event.event_image.image = params[:image]
		if event.event_image.save
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
		event = Event.find(params[:eventId])

		imageUrl = ""
		if not event.event_image.blank?
			imageUrl = event.event_image.image.url
		end
		

		puts "Details: " + event.id.to_s + " " + event.user.email + " " + event.name + " " + imageUrl
		respond_to do |format|
			format.html {render plain: event.id.to_s + " " + event.name + " " + event.user.email, status: 200 }
			format.json {render json: { eventId: event.id, owner: event.user.email, name: event.name, location: event.location, description: event.description,
				                        type: event.type, startTime: event.startTime, endTime: event.endTime, organization: event.organization,
				                        publicEvent: event.publicEvent, imageUrl: imageUrl}, status: 200 }
		end
	end

	def respondToInvite
		if Invitee.where("event_id = ? AND email = ?", params[:eventId], params[:email]).blank?
			respond_to do |format|
				format.html {render plain: "Not invited to this event", status: 400}
				format.json {render json: {msg: "Not invited to this event"}, status: 400}
			end
		elsif
			invitee = Invitee.find_by(event_id: params[:eventId], email: params[:email])
			invitee.status = params[:status]
			invitee.save
			owner = invitee.event.user.email
			notifyOwner(invitee)
			respond_to do |format|
				format.html{render plain: "Notified to owner", status: 200}
				format.json{json json: {msg: "Notified to owner"}, status: 200}
			end
		end
	end
		

	def invite
		event = Event.find(params[:eventId])
		list = params[:list].split(",")

		notify_users = Array.new
		email_users = Array.new

		list.each do |x|
			if Invitee.where("event_id = ? AND email = ?", event.id, x).blank?
				invitee = Invitee.new
				invitee.email = x
				invitee.event = event
				invitee.status = "invited"
				invitee.save
				if User.where(email: invitee.email).blank?
					email_users << invitee.email
				else
					notify_users << invitee.email
				end
			end
		end
		sendInviteNotification(notify_users, event)
		sendInviteEmail(email_users, event)

		respond_to do |format|
			format.html {render plain: "Users invited to this event", status: 200 }
			format.json {render json: { msg: "Users invited to this event" }, status: 200 }
		end
	end

	private
	def notifyOwner(invitee)
		gcm = GCM.new(API_KEY)
		reg_ids = Array.new
		if not invitee.event.user.registration_id.blank?
			puts "Notify to user: " + invitee.event.id.to_s + " " + invitee.email + " " + invitee.status + " " + invitee.event.user.email + "  " + invitee.event.user.registration_id.regid
			reg_ids << invitee.event.user.registration_id.regid
			options = {data: {type: 2, eventId: invitee.event.id, email: invitee.email, response: invitee.status}, collapse_key: "update_score"}
			response = gcm.send(reg_ids, options)
		end
	end


	def sendInviteNotification(users, event)
		gcm = GCM.new(API_KEY)
		reg_ids = Array.new
		users.each do |x|
			user = User.find_by(email: x)
			if not user.registration_id.blank?
				reg_ids << user.registration_id.regid
			end
		end
		options = {data: {type: 1, eventId: event.id, eventName: event.name, invitedBy: params[:email]}, collapse_key: "updated_score"}
		response = gcm.send(reg_ids, options)
	end

	def sendInviteEmail(users, event)
		users.each do |x|
			# TODO: send email to the user
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

	def eventId_present
		if !params[:eventId] or Event.where(id: params[:eventId]).blank?
			respond_to do |format|
				format.html {render plain: "Event not found with this id" }
				format.json {render json: { msg: "Event not found with this id" }, status: 400 }
			end
		end
	end
end
