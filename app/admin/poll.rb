ActiveAdmin.register Poll do 
	menu :parent => "Voting", :priority => 2



  before_filter :only => [:show, :destroy, :edit, :update] do
    @poll = Poll.includes(:poll_questions).friendly.find(params[:id])
    @startOrder = !(@poll.nil?) ? @poll.poll_questions.map(&:id).join(',') : ""
  end
  


	form do |f|
		f.inputs "Poll Details" do
			f.input :title, :required => true
			f.input :description, :as => :rich, :allow_embeds => true
			f.input :content, :as => :rich, :allow_embeds => true
			f.input :image, :allow_destroy => true,  :hint => f.object.image.present? \
		        ? f.template.image_tag(f.object.image.url, width: "300")
		        : f.template.content_tag(:span, 'image.')
		    if f.object.image.present? 
		        f.input :delete_image, as: :boolean, required: :false, label: 'Remove image'
		    end



		    f.input :background, :allow_destroy => true,  :hint => f.object.background.present? \
		        ? f.template.image_tag(f.object.background.url(:thumb))
		        : f.template.content_tag(:span, 'No background as yet.')
		    if f.object.background.present? 
		        f.input :delete_background, as: :boolean, required: :false, label: 'Remove background'
		    end

			f.input :start_date, required: true, as: :datetime_picker
			f.input :end_date, required: true, as: :datetime_picker

		    f.input :poll_questions,  :as => :select, :multiple => true
      
			f.form_buffers.last << hidden_field_tag("s2_poll_question_order", !(f.object.nil?) ? f.object.poll_questions.map(&:id).join(',') : "")

		end

		f.actions
	end


	
  controller do
    def update(options={}, &block)
      @order = params['s2_poll_question_order'].split(",").map(&:to_i)
  
      # This sets the attr_accessor you want later
      # params[:baz].merge!({ :last_foobar => current_foobar })
      # This is taken from the active_admin code
      super do |success, failure| 
        block.call(success, failure) if block
        failure.html { render :edit }
      end

      @order.each_with_index do |id, pos|
        # @fe = FriendEpisode.where(:friend_id => @friend.id, :episode_id => id).first
        # @fe = FriendEpisode.find_by(:friend_id => @friend.id, :episode_id => id)
        # @fe.position = pos
        # @fe.save
      end

    end


   
  end


end