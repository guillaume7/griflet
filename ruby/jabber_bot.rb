
require 'xmpp4r/client'

class JabberBot < Jabber::Client
  include Jabber
  
  def initialize(jabber_id, jabber_password, options = {})
    @jabber_id = jabber_id
    @jabber_password = jabber_password
    @options = options
    @jid = JID::new(@jabber_id)
    # super calls the base_method
    super(@jid)
  end
  
  def on_message(from, body)
    raise "on_message not implemented!"
  end
  
  def connect_and_authenticate
    connect
    auth(@jabber_password)
    send(Presence::new)
    puts "Connected! Send messages to #{@jid.strip.to_s}."
  end
  
  def run
    main = Thread.current
    add_message_callback { |message|
      next if message.type == :error or message.body.blank?
      # support exit command if owner is set
      main.wakeup if @options[:owner_jabber_id] == message.from && message.body == 'exit'
      # simple callback
      self.on_message(message.from, message.body)
    }
    Thread.stop
    close
  end
  
  def say(jabber_id, body)
    send(Message::new(jabber_id, body).set_type(:chat).set_id('1'))
  end
  
end
