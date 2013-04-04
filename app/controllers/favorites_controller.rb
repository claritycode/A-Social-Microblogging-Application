class FavoritesController < ApplicationController

	before_filter :signed_in_user

	def create
		@micropost = Micropost.find(params[:favorite][:micropost_id])
		current_user.favorite!(@micropost)
		# redirect_to root_path
		respond_to do |format|
  			format.html { redirect_to root_path }
  			format.js
		end
	end

	def destroy
		@micropost = Favorite.find(params[:id]).micropost
		current_user.unfavorite!(@micropost)
		# redirect_to root_path
		respond_to do |format|
  			format.html { redirect_to root_path }
		  	format.js
		end
	end
end