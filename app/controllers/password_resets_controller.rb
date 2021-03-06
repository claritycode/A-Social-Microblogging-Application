class PasswordResetsController < ApplicationController
  def new
  end

  #sendGrid in production,letter_opener for development and smtp settings
  def create
    if email_valid?(params[:password_reset][:email])
      user = User.find_by_email(params[:password_reset][:email])
      user.send_password_reset_email if user
      redirect_to root_url, notice: "Please check your email"
    else
      flash.now[:error] = "Invalid Email Address. Please try agian"
      render 'new'
    end
  end

  def edit
  	@user = User.find_by_password_reset_token!(params[:id])
  end

  def update
  	@user = User.find_by_password_reset_token!(params[:id])
  	@user.updating_password = true if @user
    if @user.password_reset_sent_at < 2.hours.ago
      flash[:notice] = 'Password Reset Request has expired. Please try again'
      redirect_to new_password_reset_path
  	elsif @user.update_attributes(params[:user])
      @user.password_reset_sent_at = 3.hours.ago
      @user.save
      flash[:success] = 'Your Password Reset was successful. 
      Please Sign In to Continue enjoying the service'
  		redirect_to signin_url
  	else
  		render 'edit'
  	end
  end

  def email_valid?(email)
    email.match(/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i)
  end
end
