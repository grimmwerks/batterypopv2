class PollsController < ApplicationController
	before_action :set_poll, only: [:show, :edit, :update, :destroy, :save_poll, :download]

	def index
	end


	def show
		@title = @poll.title
		if @poll.background.present? 
			@custom_background = @poll.background(:original)
		end
		@custom_background_full = true
	end

	def save_poll
		if @poll.background.present? 
			@custom_background = @poll.background(:original)
		end
		@custom_background_full = true
		
		data = []
		ids = []
		@poll.poll_questions.reorder(:order).each do |q|
			a_id = params["poll_question_#{q.id}"]
			ids << a_id
			poll_answer = PollAnswer.find(a_id.to_i)
			ChicagoVote.create(:voteable=>poll_answer)
			# vote for this poll answer
			answer_image_url = poll_answer.image.url
			# vote for @poll_answer
			data << {question_id: q.id, answer_id: a_id.to_i, img: answer_image_url}
		end

		@poll_scene = PollScene.find_scene_by_answer_ids(ids)
		if @poll_scene.nil?
			@poll_scene = PollScene.build_scene(data)
		end
	end

	def download
		send_file params[:url],:type=>"application/png", :x_sendfile=>true
	end


	def refresh_layer
		@poll_answer = PollAnswer.find(params[:answer_id])
		@poll_question = PollQuestion.find(params[:question_id])
		respond_to do |format|
			format.js
		end
	end




		private
	def set_poll
		# @friend = Friend.includes(:episodes).includes(:features).where("features.active" => true).friendly.find(params[:id])
		@poll = Poll.includes(:poll_questions).friendly.find(params[:id])
	end

	

end
