class PollsController < ApplicationController
	before_action :set_poll, only: [:show, :edit, :update, :destroy, :save_poll]

	def index
	end


	def show
		@title = @poll.title
	end

	def save_poll
		@poll.poll_questions.each do |q|
		end
	end

		private
	def set_poll
		# @friend = Friend.includes(:episodes).includes(:features).where("features.active" => true).friendly.find(params[:id])
		@poll = Poll.includes(:poll_questions).friendly.find(params[:id])
	end

	

end
