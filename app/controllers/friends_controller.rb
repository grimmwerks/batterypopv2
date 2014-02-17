class FriendsController < ApplicationController
	before_action :set_friend, only: [:show, :edit, :update, :destroy]

	def index
		@title = "Friends"
		@active = "friends"
		@friends = Friend.all
	end

	def show
		if @friend.approved
			@title = ""
		else
			redirect_to "/"
		end
	end

	

	private
	def set_friend
		@friend = Friend.includes(:episodes).includes(:features).where("features.active" => true).friendly.find(params[:id])
	end
end
