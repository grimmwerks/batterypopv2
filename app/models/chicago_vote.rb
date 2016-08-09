class ChicagoVote < ActiveRecord::Base
	belongs_to :voteable, :polymorphic => true

	has_many :episodes
	has_many :poll_answers
	# belongs_to :episode

end
