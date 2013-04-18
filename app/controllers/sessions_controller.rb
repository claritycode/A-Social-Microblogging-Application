class SessionsController < ApplicationController

	def new
	end

	def create
		user = User.find_by_email(params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
			if user.active?
				@remember_me = params[:session][:remember_me]
				sign_in user
				redirect_back_or user
			else
				flash[:error] = "Your account is not activated. Please check your email"
				redirect_to signin_url
			end
		else
			flash.now[:error] = "Invalid Email/password Combination"
		 	render 'new'
		end
	end

	def destroy
		sign_out
		redirect_to root_url
	end
end