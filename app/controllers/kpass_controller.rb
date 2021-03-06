##
## Kpass OAuth Controller Example
##
## Although this code in example is written for Ruby on Rails using the Devise
## authentication Ruby Gem, the flow of logic should be relatable to any web MVC
## framework you may be using.
##
## The following code depends on a couple of environment variables being
## configured. This will vary from application instance to application instance
## (for example, between a testing and production environment.) The values
## for these environment variables will be provided for you separately when
## getting started with Kpass.
##

class KpassController < ApplicationController
   before_filter :current_user

  # we disable forgery protection for webhooks so clients don't have to fetch a
  # token. this is rails-specific.
  protect_from_forgery except: :webhooks

  # this action is run when a user hits the '/kpass/authorize' route. we link
  # to this with all our "sign in with kpass" buttons in the sample app.
  # 
  # 
  # adding new for path  members/new?app_id
  def new
    new_url =  "#{ENV['KPASS_ENDPOINT']}/members/new?app_id=#{ENV['KPASS_APP_ID']}"
    redirect_to new_url
  end


  # when a user hits "/kpass/authorize"
  # we link to this from our 'sign in with kpass' buttons in the sample app.
  def authorize

    # redirect to kpass for authorization (and authentication if they're not
    # signed in.)
    # 
    

    authorize_url =  "#{ENV['KPASS_ENDPOINT']}/oauth/authorize?app_id=#{ENV['KPASS_APP_ID']}"
    redirect_to authorize_url
  end

  # when a user hits '/kpass/profile'
  # we link to this from our 'your account' links in the sample app.
  def profile

    # redirect to kpass where they can edit their profile and provide a url
    # where they should return in our app. for example, we can provide the url
    # of the page the link was presented on, so they return there when they're
    # done editing their profile.
    # redirect_to "#{ENV['KPASS_ENDPOINT']}?app_id=#{ENV['KPASS_APP_ID']}&return_to=#{URI::escape(params['return_to'])}"

    profile_url = "#{ENV['KPASS_ENDPOINT']}?app_id=#{ENV['KPASS_APP_ID']}&return_to=#{URI::escape(params['return_to'])}"
    redirect_to profile_url
  end

  # when a user hits '/kpass/verify'
  # this is where kpass redirects the user back to once they've authorized the
  # application, regardless of whether under-13 users have obtained permission
  # to actually share information with the sample app yet.
  def verify

    # if we haven't already authenticated a user in the sample app.
    # (this is a helper method of devise, the rails ruby gem we're using for
    # authentication in the sample app.)
    unless current_user.present?

      # we need to fetch the contents of a url, so include required libraries.
      require 'open-uri'

      # swap out our single-use token which was provided by kpass, for a secret
      # access key and some other user details for this user. this is standard
      # oauth stuff.
      verify_url = "#{ENV['KPASS_ENDPOINT']}/oauth/verify?api_key=#{ENV['KPASS_API_KEY']}&token=#{params[:token]}"
      # puts verify_url

      json = open(verify_url).read
      response = JSON.parse(json)

      # puts ""; puts "%%%%%%%%%%"; puts "verify";  puts response.inspect; puts ""

      # find or create a new user based on the username of the kpass account.
      # for over-13 users, the json will include their username (since they're
      # allowed to authorize the sharing of it.) if it's not present (because
      # they're under 13,) we generate a temporary random username that will be
      # replaced when the parent authorizes kpass to share the user's username
      # with the sample app. it will arrive via a webhook and is handled in
      # another method below. random_username is also defined below.
      kpass_id = response["member"]["id"]
      username = response["member"]["username"] || random_username

      # only create a new user record for them if we don't already have a user
      # record for their unique id.
      # @user = User.find_or_create_by(kpass_id: kpass_id)
      # 
      # 
      @user = User.find_or_create_by(kpass_id: kpass_id)
      # @user = User.where(:kpass_id => kpass_id, :username => username).first_or_create


      # set or update the username.
      @user.username = username

      @user.password = 'batterypop'  #devise throws exception without a password upon save
      @user.birthday = response["member"]["birthday"]
      @user.gender = response["member"]["gender"]
      @user.username_avatar_age_gender = response["keys"]["username_avatar_age_gender"]
      @user.access_to_moderated_chats = response["keys"]["access_to_moderated_chats"]
      @user.youtube_and_3rdparty_videos = response["keys"]["batterypop_youtube_and_3rdparty_videos"]
      @user.publish_public_profile = response["keys"]["batterypop_publish_public_profile"]

      @user.approved = response["approved"]
      @user.rejected = response["rejected"]

      # store the api key we have for this user.
      @user.kpass_access_key = response["access_key"]

      # save the user in the sample app.
      if @user.save
        sign_in(@user)
        # @_current_user = @user
        # cookies[:current_user_id] = @user.id
        # cookies[:current_user_kpass_id] = kpass_id  #trying to find a way around post method not getting current_user
      else
        raise Exception.new(@user.errors.full_messages)
      end
    end

    # if the user was bumped into the authorization workflow because they tried
    # to do something in the app that required authentication..
    # (this is a feature of devise, the rails ruby gem we're using for
    # authentication in the sample app.)
    # if session['previous_url'].present?

    #   redirect_to session[:previous_url]

    #   puts ""; puts " $$*($*$*$*$ "; puts "REDIREC TO PREVIOUS URL"; puts "";
      
    # else

    #    puts ""; puts " $$*($*$*$*$ "; puts "REDIREC TO /USERS"; puts "";

    #   redirect_to "/users"

    # end
    # 
    
    redirect_to "/users"

  end



  # when a user hits '/kpass/profile'
  def sign_out

    # mark them as signed out.
    # (this is a helper method of devise, the rails ruby gem we're using for
    # authentication in the sample app.)
    # 
    # 
    #session_sign_out    <----   NEED TO CHANGE TO CUSTOM USER SIGN OUT

    # send them back to the homepage.
    redirect_to root_path

  end

  # when kpass sends a request to '/kpass/webhooks'
  # (this is a server-to-server request)
  def webhooks
    
    data = JSON.parse(params['json'])
# puts ""
# puts data.inspect
    # if it's an authorization webhook.
    if data['type'].include?("member.authorization")

      # fetch the user for this webhook.
      user = User.find_by(kpass_id: data['data']['object']['member']['id'])
     
      # if we found the user in our sample app..
      if user.present?
       

        # if the webhook is telling us they've been approved..
        if data['type'] == "member.authorization.approved"

        # for some reason if we save user with password the session is kicked out


          # update the username of the user, since we should have access to it now
          user.username = data['data']['object']['member']['username']
          # user.password = 'batterypop'  #devise throws exception without a password upon save
          user.birthday = data['data']['object']["member"]["birthday"]
          user.gender = data['data']['object']["member"]["gender"]
          user.username_avatar_age_gender = data['data']['object']["keys"]["username_avatar_age_gender"]
          user.access_to_moderated_chats = data['data']['object']["keys"]["access_to_moderated_chats"]
          user.youtube_and_3rdparty_videos = data['data']['object']["keys"]["batterypop_youtube_and_3rdparty_videos"]
          user.publish_public_profile = data['data']['object']["keys"]["batterypop_publish_public_profile"]

          user.save



        # if the webhook is telling us that our authorization has been revoked..
        elsif data['type'] == "member.authorization.revoked"

          # destroy the user.
          # user.destroy
          anonymize_user(user)

        # if the webhook is telling us that the parent of an under-13 user has
        # denied our ability to see personal information for this user..
        elsif data['type'] == "member.authorization.rejected"

          # destroy the user.
          # user.destroy
          anonymize_user(user)
        end

      end

    end

    # communicate back to kpass that we've received the webhook.
    render json: [true]

  end

  def anonymize_user(user, params = nil)
    user.username =random_username
    user.birthday = nil
    user.gender = nil
    user.username_avatar_age_gender = nil
    user.access_to_moderated_chats = nil
    user.youtube_and_3rdparty_videos = nil
    user.publish_public_profile = nil

    user.save
  end

  # helper function to generate a random username use inbetween when an
  # under-13 user authorizes the app with kpass and when their parent authorizes
  # the sharing of their kpass username.
  def random_username
    # "batterypop-#{(rand * 10000).to_i}"
    "batterypop-#{Time.now.to_i}"
  end

end
