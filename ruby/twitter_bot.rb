
require File.dirname(__FILE__) + '/../lib/jabber_bot'
require 'twitter'

class TwitterBot < JabberBot
  TWITTER_JABBER_ID = 'twitter@twitter.com'
  attr_accessor :track_phrases
  
  def initialize(twitter_username, 
                 twitter_password,
                 jabber_id,
                 jabber_password)
    @twitter_username = twitter_username
    @twitter_password = twitter_password
    @track_phrases = []
    @followers = []
    @twitter = Twitter::Base.new(@twitter_username, @twitter_password)
    super(jabber_id, jabber_password)
  end

  def on_directed_tweet(&block); @on_directed_tweet_callback = block; end
  def on_tweet(&block); @on_tweet_callback = block; end
  def on_track(&block); @on_track_callback = block; end
  def on_follow(&block); @on_follow_callback = block; end
  def on_unfollow(&block); @on_unfollow_callback = block; end

  def on_message(from, body)
    $stdout.flush
    return unless from == TWITTER_JABBER_ID

    callback = @on_tweet_callback
    twitter_message = body.split(': ')
    twitter_body = twitter_message[1,twitter_message.size].join(': ')
    twitter_from = twitter_message.first

    # track notification?
    if (track_notification = twitter_from.match(/\((.+)\)/))
      twitter_from = track_notification[1] # Make sure that twitter_from gets set properly in case of event + @<username>
      callback = @on_track_callback
    end

    # directed tweet (@username)? overrides track notification
    directed_event = twitter_body.split(Regexp.new("^@#{@twitter_username}[, ]*"))
    if directed_event.size > 1
      twitter_body = directed_event[1]
      callback = @on_directed_tweet_callback
    end

    if callback == @on_track_callback
      phrase = determine_phrase_for_body(twitter_body)
      return callback.call(twitter_from, twitter_body, phrase)
    end

    callback.call(twitter_from, twitter_body) if callback
  rescue => e
    $stderr.puts("error parsing #{body} (#{e})")
  end
  
  def runn(options = {})
    connect_and_authenticate
    follow_all_followers if options[:follow_all_followers]
    @track_phrases.each do |phrase|
      say("untrack #{phrase}")
      sleep(3)
      say("track #{phrase}")
    end
    Thread.new do
      followers_watcher(options)
    end
    run
  end
  
  def follow(username)
    puts("following, #{username}")
    #@twitter.follow(username) # for some reason the TwitterAPI follow doesnt work
    say("follow #{username}") # using Jabber therefore
  end
  
  def say(line)
    puts("saying, #{line}")
    super(TWITTER_JABBER_ID, line)
  end
  
  def direct_message(username, message)
    #@twitter.d(username, message)
    # Better to use Jabber:
    say("d #{username} #{message}")
  end

  def determine_phrase_for_body(body)
    @track_phrases.each do |phrase|
      phrase_expression = Regexp.new(phrase)
      if phrase_expression.match(body.downcase)
        return phrase
      end
    end
    nil
  end
  
  def follow_all_followers
    following = @twitter.friends.collect { |user| user.name }
    @followers = @twitter.followers.collect { |user| user.name }
    @followers.each do |username|
      if !following.index(username)
        follow(username)
      end
    end
  end
  
  def followers_watcher(options = {})
    return unless @on_follow_callback || @on_unfollow_callback 
    options[:followers_check_wait] ||= 120
    @followers = @twitter.followers.collect { |user| user.name } if @followers.empty?
    while 1 == 1
      twitter_followers = @twitter.followers.collect { |user| user.name }
      twitter_followers.each do |username|
        if !@followers.index(username)
          @on_follow_callback.call(username) if @on_follow_callback
        end
      end
      @followers.each do |username|
        if !twitter_followers.index(username)
          @on_unfollow_callback.call(username) if @on_unfollow_callback
        end
      end
      @followers = twitter_followers
      sleep(options[:followers_check_wait])
    end
  rescue => e
    puts "ERROR IN FOLLOWERS POLLER"
    raise e
  end

end
