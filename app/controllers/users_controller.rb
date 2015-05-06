class UsersController < ApplicationController

	#def send_email
	#	GalaMailer.invite_email("avinaash.gupta50@gmail.com", Event.first).deliver
	# => render plain: "Email sent successfully"
	#end

	def sign_up
		user = User.new
		user.email = params[:email]
		user.password = params[:password]

		if user.save
			respond_to do |format|
				format.html {render plain: "User registered", status: 200 }
				format.json {render json: { msg: "User registered" }, status: 200 }
			end
		else
			respond_to do |format|
      			format.html {render plain: user.errors.messages, status: 400 }
				format.json {render json: { msg: user.errors.messages}, status: 400 }
    		end
		end
	end

	def sign_in
		if User.where("email = ? AND password = ?", params[:email], params[:password]).blank?
			respond_to do |format|
				format.html {render plain: "Username or password incorrect", status: 400 }
				format.json {render json: { msg: "Username or password incorrect" }, status: 400 }
			end
		else
			respond_to do |format|
				format.html {render plain: "Signed in", status: 200 }
				format.json {render json: { msg: "Signed in" }, status: 200 }
			end
		end
	end

	def gcm_reg_user
		if user = User.where(email: params[:email]).first
			if user.registration_id.blank?
				user.build_registration_id
			end
			user.registration_id.regid = params[:regid]
			if user.registration_id.save
				respond_to do |format|
					format.html {render plain: "User registered for GCM", status: 200 }
					format.json {render json: { msg: "User registered for GCM" }, status: 200 }
				end
			else
				respond_to do |format|
	      			format.html {render plain: user.registration_id.errors.messages, status: 400 }
					format.json {render json: { msg: user.registration_id.errors.messages}, status: 400 }
    			end
			end
		else
			respond_to do |format|
				format.html {render plain: "User doesn't exists", status: 400 }
				format.json {render json: { msg: "User doesn't exists" }, status: 400 }
			end
		end
	end
end
