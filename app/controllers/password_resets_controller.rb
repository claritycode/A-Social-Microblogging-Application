class PasswordResetsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by_email(params[:password_reset][:email])
  	user.send_password_reset_email if user
  	redirect_to root_url, notice: "Please check your email"
  end

  def edit
  end
end
