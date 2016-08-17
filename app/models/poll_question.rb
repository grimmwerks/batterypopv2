class PollQuestion < ActiveRecord::Base
	belongs_to :poll, touch: true
	has_many :poll_answers

	# has_many :chicago_votes, :as => :voteable, through: :poll_answers

	extend FriendlyId
	friendly_id :slug_candidates, use: :slugged


	accepts_nested_attributes_for :poll_answers, :allow_destroy => true

	has_attached_file :image,
    :styles => {},
    storage: :s3,
    s3_credentials: "#{Rails.root}/config/amazon_s3.yml",
    path: "images/poll_question/:id/:attachment/:filename",
    bucket: S3_BUCKET,
    default_url: "/assets/missing.png"

	  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

	  validates_presence_of :title
	  validates_presence_of :image
	  validates_attachment_presence :image
	  validates_attachment_size :image, :less_than => 5.megabytes
	  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png']

  	def delete_image
		@delete_image ||= "0"
	end
	def delete_image=(value)
		@delete_image = value
	end



  private
	def slug_candidates
		[
			:title,
			[:title, 2],
			[:title, 3],
			[:title, 4],
			[:title, 5],
			[:title, 6],
			[:title, 7],
			[:title, 8],
			[:title, 9],
			[:title,  Time.now.strftime('%M:%S') ]
		]
	end

end
