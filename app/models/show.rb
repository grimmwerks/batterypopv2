# == Schema Information
#
# Table name: shows
#
#  id                      :integer          not null, primary key
#  title                   :string(255)
#  description             :text
#  approved                :boolean
#  creator_id              :integer
#  created_at              :datetime
#  updated_at              :datetime
#  single                  :boolean
#  slug                    :string(255)
#  subtitle                :string(255)
#  image_file_name         :string(255)
#  image_content_type      :string(255)
#  image_file_size         :integer
#  image_updated_at        :datetime
#  background_file_name    :string(255)
#  background_content_type :string(255)
#  background_file_size    :integer
#  background_updated_at   :datetime
#  promote                 :boolean
#  skiplist                :boolean
#  position                :integer
#  age_range               :string(255)
#

class Show < ActiveRecord::Base
	include PgSearch
	include DashboardUtility
	# multisearchable :against => [:title, :description]
	# 
	before_save :set_sort_title
	after_save :set_search_link

	pg_search_scope :search_text,
	      :against => [:title, :description],
	      :using => {
	        :tsearch => {:prefix => true}
	      }


	extend FriendlyId
	friendly_id :slug_candidates, use: :slugged
	
	
	acts_as_followable
	acts_as_taggable_on :keywords
	belongs_to :creator

	has_many :episodes, :order => 'episode ASC'

	# has_many :episodes_approved, :class_name => "Episode", :conditions => ["approved = ?", true]
	has_many :episodes_approved, -> { where(approved: true).order('episode ASC') }, class_name: 'Episode'


	has_many :links, as: :linkedmedia, through: :episodes
	# has_many :visits, through: :links

	has_and_belongs_to_many :channels, :join_table => :channels_shows 

	accepts_nested_attributes_for :episodes, :allow_destroy => true
		#:reject_if => ->(e) { e[:title].blank? }, :allow_destroy => true


	has_attached_file :image,
	    :styles => { large: "864x486>", 
	    	:thumb => "150x150#",
	    	:roku_sd => "214x144^",
	    	:roku_hd => "290x218^",
	    	:listing => "200x200>"
	    	 },
	    storage: :s3,
	    s3_credentials: "#{Rails.root}/config/amazon_s3.yml",
	    path: "images/:class/:id/:attachment/:style/:filename",
	    bucket: S3_BUCKET,
	    default_url: "/assets/missing.png"

	has_attached_file :background,
	    :styles => { background: "1600x1100>", large: "864x486>", thumb: "150x150#" },
	    storage: :s3,
	    s3_credentials: "#{Rails.root}/config/amazon_s3.yml",
	    path: "images/:class/:id/:attachment/:style/:filename",
	    bucket: S3_BUCKET,
	    default_url: "/assets/missing.png"

	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
	validates_attachment_content_type :background, :content_type => /\Aimage\/.*\Z/

	  
#search return helpers
def link
	return "/shows/" + self.slug
end

def episode_link(episode)
	self.link + '/episodes/' + episode.slug
end

def thumb
	return (self.image(:thumb))
end

def search_valid?
	!!(approved)
end

def creator_name
	return creator.username
end

# total show episodes pops
def total_episode_pops
	self.episodes.inject(0){|sum, ep| sum + ep.pops}
end

# dashboard methods
def followers_by_gender
	DashboardUtility.users_to_census_gender_count(self.followers, true)
end

def followers_by_age
	DashboardUtility.users_to_census_age_count(self.followers, true)
end

def voters_from_show_episodes
	h = Array.new
	self.episodes.each do |ep|
		voters = ep.votes.up.by_type(User).voters
		voters.each do |voter|
			h << voter unless h.include?(voter)
			# ap voter
		end
	end
	return h
end

def hide_sponsor_listing?
	return false
end

def episodes_votes_by_age
	voters = self.voters_from_show_episodes
	DashboardUtility.users_to_census_age_count(voters, true)
end

def episodes_votes_by_gender
	voters = self.voters_from_show_episodes
	DashboardUtility.users_to_census_gender_count(voters, true)
end


def should_generate_new_friendly_id?
  slug.blank? || title_changed?
end

def self.created_yesterday
	created_between((Time.zone.now-1.day).beginning_of_day, (Time.zone.now-1.day).end_of_day)
end

def self.created_last_week
	created_between((Time.zone.now-1.week).beginning_of_day, Time.zone.now)
end

def self.created_last_month
	created_between((Time.zone.now-1.month).beginning_of_day, Time.zone.now)
end

def self.created_last_year
	created_between((Time.zone.now-1.year).beginning_of_day, Time.zone.now)
end

# pg search fixes
def set_search_link
	ret = PgSearchDocuments.where(searchable_id: self.id, searchable_type: self.class.name)
	if ret.count
		ret.each do |d|
			d.delete
		end
	end
	pd = PgSearchDocuments.new({content: self.title, searchable_id: self.id, searchable_type: self.class.name}); pd.save
	pd = PgSearchDocuments.new({content: self.description, searchable_id: self.id, searchable_type: self.class.name}); pd.save
end


def set_sort_title
	self.sort_title = self.slug.sub(/^the-/,'')
end


scope :created_between, lambda { |start_time, end_time| where(:created_at => (start_time...end_time)) }





scope :approved,  -> {where(:approved => true)}
scope :not_approved,  ->  {where(:approved => false)}


# scope :promoted, where (:promote => true)
scope :promoted,  ->  {where(:promote => true )}

#not sure how best to deal with nul values
scope :skiplistnil, -> {where(:skiplist => nil)}
scope :skiplisttrue, ->{where(:skiplist => true)}
scope :skiplistfalse, ->{where(:skiplist => false)}

scope :showlist, -> {where(:skiplist => [false, nil])}

scope :shorts,  -> {where(:single => true, :approved => true)}
scope :series, -> {where(:single => [false, nil], :approved => true)}





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

	def show_params
		params.require(:show).permit(:title, :description, :single, :slug, :episodes_attributes, :image, :background)
	end

	

end
