class PollAnswersPollScene < ActiveRecord::Base
	# weirdly named plural
	belongs_to :poll_answer
	belongs_to :poll_scene
end