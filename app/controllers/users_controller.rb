class UsersController < ApplicationController

	def sign_up
		user = User.new
		user.email = params[:email]
		user.password = params[:password]

		if User.find_by(email: params[:email])
			respond_to do |format|
				format.html {render plain: "User already exists", status: 400 }
				format.json {render json: { msg: "User already exists" }, status: 400 }
			end
		elsif user.save
			respond_to do |format|
				format.html {render plain: "User registered", status: 200 }
				format.json {render json: { msg: "User registered" }, status: 200 }
			end
		else
			respond_to do |format|
      			format.html {render plain: "Email or password is blank", status: 400 }
				format.json {render json: { msg: "Email or password is blank"}, status: 400 }
    		end
		end
	end

	def sign_in
		if User.where("email = ? AND password = ?", 	params[:email], params[:password]).blank?
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
		regId = RegistrationId.new
		regId.email = params[:email]
		regId.regid = params[:regid]

		if User.where("email = ?", 	params[:email]).blank?
			respond_to do |format|
				format.html {render plain: "User doesn't exists", status: 400 }
				format.json {render json: { msg: "User doesn't exists" }, status: 400 }
			end
		elsif not RegistrationId.where("email = ?", params[:email]).blank?
			respond_to do |format|
				format.html {render plain: "User already registered with gcm", status: 400 }
				format.json {render json: { msg: "User already registered with gcm" }, status: 400 }
			end
		elsif regId.save
			respond_to do |format|
				format.html {render plain: "User registered for GCM", status: 200 }
				format.json {render json: { msg: "User registered for GCM" }, status: 200 }
			end
		else
			respond_to do |format|
      			format.html {render plain: "Email or regid is blank", status: 400 }
				format.json {render json: { msg: "Email or regid is blank"}, status: 400 }
    		end
		end
	end
end
