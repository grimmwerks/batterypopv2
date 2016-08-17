class PollScene < ActiveRecord::Base
	has_many :poll_answers_poll_scenes, :dependent => :destroy
	has_many :poll_answers, through: :poll_answers_poll_scenes
	has_many :poll_questions, through: :poll_answers
	has_many :polls, through: :poll_questions

	before_create :rewrite_image_name

	has_attached_file :image,
		:styles => {},
		storage: :s3,
		s3_credentials: "#{Rails.root}/config/amazon_s3.yml",
		path: "images/poll_scene/:id/image/:filename",
		bucket: S3_BUCKET,
		default_url: "/assets/missing.png",
		:s3_headers => lambda { |attachment|
                        {
                          'Cache-Control' => 'max-age=315576000',
                          'Expires' => 10.years.from_now.httpdate,
                          'Content-Disposition' => "attachment; filename=luckys_adventure.png",
                          'Content-Type' => 'image/png'
                        }
                      }


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
		name = data.map{|item| "question_#{item[:question_id]}_#{item[:answer_id]}"}.join("-")
		@poll_scene = PollScene.new(name: name, image: File.open(@result))
		@poll_scene.poll_answer_ids = ids
		@poll_scene.save

		return @poll_scene
	end

	def self.find_scene_by_answer_ids(ids)
		sql = "SELECT poll_scenes.* FROM poll_scenes INNER JOIN poll_answers_poll_scenes ON poll_answers_poll_scenes.poll_scene_id = poll_scenes.id INNER JOIN poll_answers ON poll_answers.id = poll_answers_poll_scenes.poll_answer_id WHERE poll_answers.id IN (#{ids.join(',')}) group by poll_scenes.id having count(distinct poll_answers.id) = #{ids.count}"
		PollScene.find_by_sql(sql).first

	end
	
	private
	def poll_scene_params
	    params[:poll_scene].permit(:name,  poll_answers_ids: [])
	end

	def rewrite_image_name
		extension = File.extname(image_file_name).downcase
	    self.image.instance_write(:file_name, "luckys_adventure-#{self.name}.png")
	end


end
