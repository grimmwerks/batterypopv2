# == Schema Information
#
# Table name: episodes
#
#  id                 		:integer          not null, primary key
#  title              		:string(255)
#  description        		:text
#  approved           		:boolean
#  slug               		:string(255)
#  sponsor			  		:string(255)
#  created_at              :datetime
#  updated_at              :datetime
#  image_file_name         :string(255)
#  image_content_type      :string(255)
#  image_file_size         :integer
#  image_updated_at        :datetime
#  background_file_name    :string(255)
#  background_content_type :string(255)
#  background_file_size    :integer
#  background_updated_at   :datetime
#  features_autoplay	   :boolean
#  features_exit		   :string(255)

#  episodes

class Friend < ActiveRecord::Base
	include PgSearch
	multisearchable :against => [:title, :description, :sponsor]

	extend FriendlyId
	friendly_id :slug_candidates, use: :slugged

	acts_as_followable

	has_many :friend_episodes
	has_many :episodes, :through => :friend_episodes
	has_many :shows, :through => :episodes
	
	has_many :features, :as => :owner

	accepts_nested_attributes_for :features

	#image stuff
	has_attached_file :image,
	    :styles => { hd: "1056x594>", large: "300x300>", node: "250x250>", :thumb => "100x100>" },
	    storage: :s3,
	    s3_credentials: "#{Rails.root}/config/amazon_s3.yml",
	    path: "images/friends/:id/image/:attachment/:style/:filename",
	    bucket: S3_BUCKET,
	    default_url: "/assets/missing.png"

	has_attached_file :background,
	    :styles => { full: "1600x1100>", large: "300x300>", node: "250x250>", :thumb => "100x100>" },
	    storage: :s3,
	    s3_credentials: "#{Rails.root}/config/amazon_s3.yml",
	    path: "images/friends/:id/background/:attachment/:style/:filename",
	    bucket: S3_BUCKET

	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
	validates_attachment_content_type :background, :content_type => /\Aimage\/.*\Z/

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