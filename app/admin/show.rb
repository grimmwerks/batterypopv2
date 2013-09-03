ActiveAdmin.register Show do
	menu :parent => "BatteryPOP Shows"

	before_filter :only => [:show, :destroy, :edit, :update] do
		@show = Show.friendly.find(params[:id])
	end
	
	form  do |f|  
		f.inputs "Show Details" do
			f.input :creator, :as => :select, :member_label => :displayname, :required => true
			f.input :title, :label => "Show Title", :required => true 
			f.input :description,  :label => "Description", :as => :rich, :allow_embeds => true
			f.input :single, :label => "Single episode?", :hint => "Set to true for short or non-episodic video."
			f.input :approved, :label => "BatteryPOP approved."
		end
		 f.inputs "Episodes" do
		 	f.has_many :episodes do |e|
		 		e.input :title, :required => true
				e.input :description, :as => :rich
				e.input :embed, :as => :select, :member_label => :provider, :required => true
				e.input :video, :label => "Video Code"
		 	end

		 end
		 f.inputs "Show Channels" do
			f.input :channels, :as => :check_boxes, :input_html => { :multiple => true } 
		end
		f.buttons
	end

	index do
		column :creator, :as => :select, :member_label => :displayname
		column :title
		column :description
		column :single, :as => :check_box
		column :approved
		default_actions
	end

	action_item :only => :show do
	    # link_to('View on site', show_path(show))
	    # (show_path(show)).inspect
	end

	# show do
	#  	h3 show.title
	#       div do
	#         simple_format show.description
	#       end
	# end


	 # show do |ad|
  #     attributes_table do
  #       row :title
  #       row :image do
  #         image_tag(ad.image.url)
  #       end
  #     end
  #     active_admin_comments
  #   end


end
