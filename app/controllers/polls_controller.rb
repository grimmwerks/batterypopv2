class PollsController < ApplicationController
	before_action :set_poll, only: [:show, :edit, :update, :destroy, :save_poll]

	def index
	end


	def show
		@title = @poll.title
	end

	def save_poll
		answer_txt=""
		imgs = []
		@poll.poll_questions.each do |q|
			a_id = params["poll_question_#{q.id}"]
			poll_answer = PollAnswer.find(a_id.to_i)
			answer_image = poll_answer.image
			# vote for @poll_answer
			imgs << {question_id: q.id, answer_id: a_id, img: answer_image, offset_x: q.offset_x, q: poll_answer.offset_y}
		end

		binding.pry
	end


	# def upload_to_s3 bucket_name, key, file
	#   s3 = AWS::S3.new(:access_key_id => 'YOUR_ACCESS_KEY_ID', :secret_access_key => 'YOUR_SECRET_ACCESS_KEY')
	#   bucket = s3.buckets[bucket_name]
	#   obj = bucket.objects[key]
	#   obj.write(File.open(file, 'rb'), :acl => :public_read)
	# end

		private
	def set_poll
		# @friend = Friend.includes(:episodes).includes(:features).where("features.active" => true).friendly.find(params[:id])
		@poll = Poll.includes(:poll_questions).friendly.find(params[:id])
	end

	

end
