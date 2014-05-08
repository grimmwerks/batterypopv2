class ShowsController < ApplicationController
  before_action :set_show, only: [:show, :edit, :update, :destroy, :follow, :unfollow]

 

  def index
    @active="shows"
    @title = "Shows"
    # @shows = Show.all
    @shows=Show.series.order(:created_at).includes(:episodes).paginate(:page => params[:page], :per_page => 8)
    @description = "The best web series around! Catch the shows everyone is talking about right here, and share your favorites with your friends."
  end

  # GET /shows/1
  # GET /shows/1.json
  def show
     @active="shows"
     @show_follow_status = ''
     # @f = @show.user_followers.random(5)
     # @followers = (@f.compact!).nil? ? @f : @f.compact!

     @followers = @show.user_followers.offset(rand(@show.user_followers.count)).limit(5)
     @description = @show.description
    if(@episode.nil?) 
       @episode = @show.episodes.first
    end



    @title = @show.title + ' : ' + @episode.title
  
    @ga_custom = "ga('set', 'dimension1', '#{@show.creator.id}');"

    if(!@episode.tag_list.empty?)
        @page_keywords =  @episode.tag_list.to_s
    end

    # if current user following
   if !current_user.nil? && current_user.following?(@show)
       @show_follow_status = "You are following"
   else
       @show_follow_status = "status"
   end
    
    @likers = @episode.votes.up.by_type(User).voters.compact
    # @voters = Votes.where(votable: @episode).random(3).map(&:voter)
  end



  def follow
    unless current_user.nil?
      current_user.follow(@show)
      @show_follow_status = "You are following"
      # respond_to do |format|
      #   format.js {render :action=>"follow"}
      # end
    end
  end

  def unfollow
    unless current_user.nil?
      current_user.stop_following(@show)
       @show_follow_status = ""
    end
    # respond_to do |format|
    #   format.js {render :action=>"unfollow"}
    # end
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_show
    # @show = Show.find(params[:id])
     # @show = Show.friendly.find(params[:id])
     #@show = Show.includes(:episodes).where("episodes.approved" => true).friendly.find(params[:id])
     @show = Show.includes(:episodes).where("episodes.approved" => true).order('episodes.episode').friendly.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def show_params
    params.require(:show).permit(:title, :description, :approved)
  end






end
