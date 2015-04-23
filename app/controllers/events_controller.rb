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

	def info
		if Event.find(params[:eventId])
			event = Event.find(params[:eventId])
			respond_to do |format|
				format.html {render plain: event.id + " " + event.name, status: 200 }
				format.json {render json: { eventId: event.id, name: event.name, location: event.location, description: event.description,
					                        type: event.type, startTime: event.startTime, endTime: event.endTime, organization: event.organization,
					                        publicEvent: event.publicEvent}, status: 200 }
			end
		elsif
			respond_to do |format|
				format.html {render plain: "Event not found", status: 400 }
				format.json {render json: { msg: "Event not found" }, status: 400 }
			end
		end
			
			

	def invite
		usersInvited = Array.new
		list = params[:list].split(",")
		eventId = params[:eventId]
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
		sendNotification(usersInvited)
		sendEmail(usersInvited)

		respond_to do |format|
			format.html {render plain: "Invited users", status: 200 }
			format.json {render json: { msg: usersInvited }, status: 200 }
		end
	end

	private	

	def sendNotification(users)
		gcm = GCM.new(API_KEY)
		reg_ids = Array.new
		users.each do |x|
			if RegistrationId.find_by(email: x)
				rUser = RegistrationId.find_by(email: x)
				reg_ids << rUser.regid
			end
		end
		options = {data: {type: 1, eventId: params[:eventId], email: params[:email]}, collapse_key: "updated_score"}
		response = gcm.send(reg_ids, options)
	end

	def sendEmail(users)
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
end
