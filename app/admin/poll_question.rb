ActiveAdmin.register PollQuestion do 
	menu :parent => "Voting", :priority => 1


    controller do
        def scoped_collection
           super.eager_load(:poll_answers)
        end
    end


  before_filter :only => [:show, :destroy, :edit, :update] do
    @poll_question = PollQuestion.includes(:poll_answers).friendly.find(params[:id])
    # @startOrder = !(@poll.nil?) ? @poll.poll_questions.map(&:poll_question_id).join(',') : ""
  end


	form do |g|


		g.inputs "Poll Questions" do
			g.input :title, :required => true
			g.input :order
			g.input :description, :as => :rich, :allow_embeds => true
			g.input :image,  :hint => g.object.image.present? \
	        ? g.template.image_tag(g.object.image.url, width: "300")
	        : g.template.content_tag(:span, 'image.')
            g.input :data
		end

		 g.inputs "Poll Answers" do
        	g.has_many :poll_answers, :allow_destroy => true do |h|
        		
        		h.input :title

        		h.input :slide_image, :allow_destroy => true, :hint => h.object.slide_image.present? \
        		? h.template.image_tag(h.object.slide_image.url) : h.template.content_tag(:span, 'Selection Image')
        		# if h.object.slide_image.present?
        		# 	h.input :delete_slide_image, as: :boolean, required: false, label: 'Remove slide image'
        		# end
        		
                h.input :image, :allow_destroy => true, :hint => h.object.image.present? \
                ? h.template.image_tag(h.object.image.url(:preview)) : h.template.content_tag(:span, 'Image')
                # if h.object.image.present?
                #     h.input :delete_image, as: :boolean, required: false, label: 'Remove image'
                # end
        		
        	end
        end

        g.actions
	end


end