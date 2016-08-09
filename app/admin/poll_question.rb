ActiveAdmin.register PollQuestion do 
	menu :parent => "Voting", :priority => 1



  before_filter :only => [:show, :destroy, :edit, :update] do
    @poll_question = PollQuestion.includes(:poll_answers).friendly.find(params[:id])
    # @startOrder = !(@poll.nil?) ? @poll.poll_questions.map(&:poll_question_id).join(',') : ""
  end


	form do |g|


		g.inputs "Poll Questions" do
			g.input :title, :required => true
			g.input :order
			g.input :offset_x
			g.input :offset_y
			g.input :description, :as => :rich, :allow_embeds => true
			g.input :image,  :hint => g.object.image.present? \
	        ? g.template.image_tag(g.object.image.url)
	        : g.template.content_tag(:span, 'image.')

		end

		 g.inputs "Poll Answers" do
        	g.has_many :poll_answers, :allow_destroy => true do |h|
        		
        		h.input :title
        		h.input :image, :allow_destroy => true, :hint => h.object.image.present? \
        		? h.template.image_tag(h.object.image.url) : h.template.content_tag(:span, 'Image')
        		# if h.object.image.present?
        		# 	h.input :delete_image, as: :boolean, required: false, label: 'Remove image'
        		# end
        		
        		
        	end
        end

        g.actions
	end


end