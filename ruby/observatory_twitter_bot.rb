
require File.dirname(__FILE__) + '/../lib/twitter_bot'
require 'drb'

class ObservatoryTwitterBot < TwitterBot
  attr_accessor :logger
  
  def initialize(logger)
    self.logger = logger
    super(OBSERVATORY_TWITTER_USERNAME, OBSERVATORY_TWITTER_PASSWORD, OBSERVATORY_JABBER_ID, OBSERVATORY_JABBER_PASSWORD)
  end
  
  def runn
    #self.track_phrases = ['observatory.topoints.com', '#observatory']
    logger.info("starting ObservatoryTwitterBot, twitter_username: #{OBSERVATORY_TWITTER_USERNAME}, jabber_id: #{OBSERVATORY_JABBER_ID}")
    self.on_directed_tweet do |username, message|
      logger.info("directed tweet: #{username} says #{message}")
      if (phrase = track_phrase(message))
        logger.info("tracking '#{phrase}' for user #{username}")
        begin
          self.direct_message(username, "Will send a direct message anytime something happens in the Blogosphere regarding '#{phrase}'")
          Tracker.for(username, phrase)
        rescue => e
          logger.error("tracking failure: #{e.to_s}")
        end
      end
      if (phrase = untrack_phrase(message))
        logger.info("untracking '#{phrase}' for user #{username}")
        begin
          Tracker.off_for(username, phrase)
        rescue => e
          logger.error("tracking failure: #{e.to_s}")
        end
      end
      self.direct_message(username, 'pong') if message == 'ping'
    end
    self.on_tweet do |username, message|
      logger.info("something from #{username}: #{message}")
    end
    self.on_track do |username, message, phrase|
      logger.info("track: #{username} says #{message}")
    end
    
    # These events are generated every 120 secs :(
    self.on_follow do |username|
      logger.info("#{username} is following us, will follow #{username} too and send welcome message")
      follow(username)
      self.direct_message(username, "the Observatory is now ready to serve you, use '@observatory track [keyword]' to get blogosphere updates.")
    end
    self.on_unfollow do |username|
      logger.info("#{username} stopped following us")
    end
    DRb.start_service("druby://:8997", self)
    super(:follow_all_followers => true)
  end
  
  def track_phrase(message)
    match_phrase('track', message)
  end
  
  def untrack_phrase(message)
    match_phrase('off', message)
  end
  
private

  def match_phrase(command, message)
    expression = Regexp.new("^[\s]*#{command}[\s]+['\"]*([^'\"]+)['\"]*")
    if (md = expression.match(message))
      phrase = md[1]
      if phrase.size < 4
        return nil
      end
      return phrase
    end
    nil
  end
  
end
