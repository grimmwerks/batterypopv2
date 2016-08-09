class PollAnswer < ActiveRecord::Base
	belongs_to :poll_question, touch: true

	acts_as_votable
	has_many :chicago_votes, :as => :voteable

	has_attached_file :image,
    :styles => {},
    storage: :s3,
    s3_credentials: "#{Rails.root}/config/amazon_s3.yml",
    path: "images/poll_answer/:id/:attachment/:filename",
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




end
