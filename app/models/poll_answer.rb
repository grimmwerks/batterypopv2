class PollAnswer < ActiveRecord::Base
	belongs_to :poll_question, touch: true

	has_many :poll_answers_poll_scenes
	has_many :poll_scenes, through: :poll_answers_poll_scenes


	acts_as_votable
	has_many :chicago_votes, :as => :voteable

	has_attached_file :slide_image,
    :styles => {},
    storage: :s3,
    s3_credentials: "#{Rails.root}/config/amazon_s3.yml",
    path: "images/poll_answer/:id/:attachment/:filename",
    bucket: S3_BUCKET,
    default_url: "/assets/missing.png"

	has_attached_file :image,
    :styles => {preview: "250x250#", large: '1000x1000>' },
    storage: :s3,
    s3_credentials: "#{Rails.root}/config/amazon_s3.yml",
    path: "images/poll_answer/:id/:attachment/:style/:filename",
    bucket: S3_BUCKET,
    default_url: "/assets/missing.png"

	  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
	  validates_attachment_content_type :slide_image, :content_type => /\Aimage\/.*\Z/

	  validates_presence_of :title
	  validates_presence_of :slide_image
	  validates_attachment_presence :slide_image
	  validates_attachment_size :slide_image, :less_than => 5.megabytes
	  validates_attachment_content_type :slide_image, :content_type => ['image/jpeg', 'image/png']

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

	def delete_slide_image
		@delete_slide_image ||= "0"
	end
	def delete_slide_image=(value)
		@delete_slide_image = value
	end



end
