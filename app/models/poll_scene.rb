class PollScene < ActiveRecord::Base
	has_many :poll_answers_poll_scenes, :dependent => :destroy
	has_many :poll_answers, through: :poll_answers_poll_scenes
	has_many :poll_questions, through: :poll_answers
	has_many :polls, through: :poll_questions


	has_attached_file :image,
		:styles => {},
		storage: :s3,
		s3_credentials: "#{Rails.root}/config/amazon_s3.yml",
		path: "images/poll_scene/:id/image/:filename",
		bucket: S3_BUCKET,
		default_url: "/assets/missing.png"

	validates_presence_of :image
	validates_attachment_presence :image
	validates_attachment_size :image, :less_than => 5.megabytes
	validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png']

	def self.build_scene(data)
		# can look up connection first with incoming data and return
		@result = nil
		ids = []
		data.each do |i|
			puts "result is: #{@result}"
			if @result.nil?
				@result = i[:img]
			else
				img1 = MiniMagick::Image.open(@result)
				img2 = MiniMagick::Image.open(i[:img])
				res = img1.composite(img2) do |c|
				  c.compose "Over"    # OverCompositeOp
				  # c.geometry "+#{i[:offset_x]}+#{i[:offset_y]}" # copy second_image onto first_image from (20, 20)
				end
				@result = res.path
			end
			ids<<i[:answer_id]
		end
		name = ids.map{|k| "pollanswer_#{k}"}.join("-")
		@poll_scene = PollScene.new(name: name, image: File.open(@result))
		if @poll_scene.save? 
			@poll_scene.poll_answers_ids = ids
		end
		return @poll_scene
	end

	private
	def poll_scene_params
	    params[:poll_scene].permit(:name,  poll_answers_ids: [])
	  end


end
