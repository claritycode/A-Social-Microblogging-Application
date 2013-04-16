class FavoritesController < ApplicationController

	before_filter :signed_in_user

	def create
		@micropost = Micropost.find(params[:favorite][:micropost_id])
		current_user.favorite!(@micropost)
		respond_to do |format|
  			format.html { redirect_to root_url }
  			format.js
		end
	end

	def destroy
		@micropost = Favorite.find(params[:id]).micropost
		current_user.unfavorite!(@micropost)
		respond_to do |format|
  			format.html { redirect_to root_url }
		  	format.js
		end
	end
end