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
		@poll_scene.poll_answer_ids = ids
		@poll_scene.save

		return @poll_scene
	end

	def self.find_scene_by_answer_ids(ids)
		sql = "SELECT poll_scenes.* FROM poll_scenes INNER JOIN poll_answers_poll_scenes ON poll_answers_poll_scenes.poll_scene_id = poll_scenes.id INNER JOIN poll_answers ON poll_answers.id = poll_answers_poll_scenes.poll_answer_id WHERE poll_answers.id IN (#{ids.join(',')}) group by poll_scenes.id having count(distinct poll_answers.id) = #{ids.count}"
		ret = PollScene.find_by_sql(sql)
		if ret.count
			return ret
		else
			return nil
		end
	end
	
	private
	def poll_scene_params
	    params[:poll_scene].permit(:name,  poll_answers_ids: [])
	  end


end
