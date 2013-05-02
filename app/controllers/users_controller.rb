class UsersController < ApplicationController
  
  before_filter :signed_in_user,
     only: [:edit, :update, :index, :destroy, :followers, :following, :mentions, :favorites]
  
  before_filter :correct_user, only: [:edit, :update, :mentions]

  before_filter :admin_user, only: :destroy

  def index
    #@users = User.all
    # Paginate returns ActiveRecord::Relation object, this method is 
    #provided by will_paginate, params[:page] also comes from it
    # @users = User.paginate(page: params[:page]) 
    unless params[:search].blank?
      @users = User.search(params[:search]).paginate(page: params[:page])
    else
      @users = User.paginate(page: params[:page])
    end
  end

  def show
  	@user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
  	@user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      @user.send_signup_confirmation_email
      redirect_to root_url, 
      notice: 'To complete your account activation please check your email'
      # sign_in @user
      # flash[:success] = "Welcome to the Sample App"
      # redirect_to @user
    else
      render 'new'
    end
  end 

  def edit
  end

  def update
    @user.updating_password = true
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User Destroyed"
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def mentions
    # @title = "Mentions"
    # @user = current_user
    # @user = User.find(params[:id])
    @mentions = @user.mentioned_microposts.paginate(page: params[:page])
    render 'show_mentions'
  end  

  def favorites
    @title = "Favorites"
    @user = User.find(params[:id])
    @favorites = @user.favorited_microposts.paginate(page: params[:page])
    render 'show_favorites'
  end

  def confirm
    user = User.find_by_remember_token(params[:id])
    if user
      if user.activate
        sign_in user
        flash[:success] = 'Your Account is now activated. Welcome'
        redirect_to root_url
      else
        sign_out if signed_in?
        redirect_to signin_url, 
        notice: 'Your account is already activated. Please sign in instead'  
      end  
    else
      flash[:error] = 'Invalid Request'
      redirect_to root_url
    end   
  end
  
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end
end
