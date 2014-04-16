class CreatorsController<ApplicationController
	before_action :set_creator, only: [:show]

	def index
		@creators = Creator.all
	end

	def show
		if !@creator.hidden?
			@title = "Creator: #{@creator.displayname}"
			@description = "Creator: #{@creator.displayname} #{@creator.bio}"
		else
			redirect_to "/"
		end
	end

	def dashboard
		# @title ="DASHBOARD"
		# ap current_creator
		
		if current_creator.nil? 
			redirect_to "/creators/sign_in"
		else
			@creator = current_creator
			@title = "Dashboard: #{current_creator.displayname}"
		end
	end

	private
	def set_creator
		@creator = Creator.includes(:shows).friendly.find(params[:id])
	end
	def creator_params
		params.require(:creator).permit(:displayname, :username)
	end
end