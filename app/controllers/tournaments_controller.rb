class TournamentsController < ApplicationController
  before_action :set_tournament, only: [:show, :edit, :update, :destroy, :follow, :unfollow]



  def index
    @active="tournaments"
    @title = "Tournaments"



    # @shows = Show.all
    @shows=Show.series.order(:created_at).includes(:episodes).paginate(:page => params[:page], :per_page => 8)
    @description = "Vote for your favorite episode in this head-to-head matchup!"
  end

  def vote
    match = Match.find(params[:id])
    episode = Episode.find(params[:episode_id])
    addr = request.env['HTTP_X_FORWARDED_FOR']
    addr = addr && addr.split(",").last
    puts "#{addr} voted for #{params[:id]}"
    now = Time.now
    # if (!TournamentVote.where(match: match, address: addr).empty? || match.status != "active")
    # 
    if (!TournamentVote.where(match: match, address: addr, :created_at => (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).empty? || match.status != "active")
      head :forbidden
    else
      TournamentVote.create(match: match, episode: episode, address: addr)
      head :ok
    end
  end


  # GET /shows/1
  # GET /shows/1.json
  def show
    @banner_ad = "/31902320/Shows_Leaderboard"
    @banner_id = 'div-gpt-ad-1411894829676-0'
     @dfp_header = "tournaments"
     @active="tournaments"
     @show_follow_status = ''
     # @f = @show.user_followers.random(5)
     # @followers = (@f.compact!).nil? ? @f : @f.compact!
     # 
    @dfp_header_code = @tournament.dfp_header_code
    @dfp_banner_ad = @tournament.dfp_banner_ad


    if(@episode.nil?)
       @episode = @tournament.episodes.first
    end

    @matches = @tournament.active_matches


    @ga_page_params = ", {'dimension1':  '#{@episode.creator.id}', 'dimension2': '#{@episode.id}'}"

    #we want to have different items based on single or episodic info
    @description = @tournament.description
    @title = @tournament.title



    #meta fun
    @meta_description = "#{@title} - #{@episode.description}"
    if(!@episode.tag_list.empty?)
        @page_keywords = @episode.tag_list.to_s
    end
    if(!@episode.keyword_list.empty?)
        @page_keywords = @episode.keyword_list.to_s
    end
    # if current user following
   # if !current_user.nil? && current_user.following?(@tournament)
   #     @show_follow_status = "You are following"
   # else
   #     @show_follow_status = "status"
   # end

    @likers = @episode.votes.up.by_type(User).voters.compact
    # @voters = Votes.where(votable: @episode).random(3).map(&:voter)
  end



  def follow
    unless current_user.nil?
      current_user.follow(@show)
      @show_follow_status = "You are following"
      current_user.touch  # cache clear; TODO: sweeper?
      # respond_to do |format|
      #   format.js {render :action=>"follow"}
      # end
    end
  end

  def unfollow
    unless current_user.nil?
      current_user.stop_following(@show)
       @show_follow_status = ""
       current_user.touch  # cache clear; TODO: sweeper?
    end
    # respond_to do |format|
    #   format.js {render :action=>"unfollow"}
    # end
  end

  def edit
    redirect_to "/"
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_tournament
    # @show = Show.find(params[:id])
    @tournament = Tournament.friendly.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def show_params
    params.require(:show).permit(:title, :description, :approved)
  end






end
