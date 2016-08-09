class Poll < ActiveRecord::Base
	has_many :poll_questions
	has_many :poll_answers, through: :poll_questions

	extend FriendlyId
	friendly_id :slug_candidates, use: :slugged

	accepts_nested_attributes_for :poll_questions, :allow_destroy => true
	# accepts_nested_attributes_for :poll_answers, through: :poll_questions, :allow_destroy => true

	has_attached_file :image,
		:styles => {},
		storage: :s3,
		s3_credentials: "#{Rails.root}/config/amazon_s3.yml",
		path: "images/poll/:id/image/:attachment/:filename",
		bucket: S3_BUCKET,
		default_url: "/assets/missing.png"

	has_attached_file :background,
	    :styles => { full: "1600x1100>", large: "300x300>",  :thumb => "100x100>" },
	    storage: :s3,
	    s3_credentials: "#{Rails.root}/config/amazon_s3.yml",
	    path: "images/poll/:id/background/:attachment/:style/:filename",
	    bucket: S3_BUCKET


	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
	validates_attachment_content_type :background, :content_type => /\Aimage\/.*\Z/

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


	def delete_background
		@delete_background ||= "0"
	end
	def delete_background=(value)
		@delete_background = value
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
