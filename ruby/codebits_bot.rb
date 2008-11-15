#!/usr/bin/env ruby
require 'jabber/bot'
require 'socket'

def sendreceive(request,ip='85.247.250.5',port=13568)
    puts "initializing socket..."
    TCPSocket.open(ip, port.to_i) do |sock|
        puts "done\n"
        puts "sending request..."
        sock.write(request)
        puts "done\n"
        puts "getting answer..."
        result = sock.read(100)
        puts "done\n"
        sock.close
        return result
    end
end

# Create a public Jabber::Bot
bot = Jabber::Bot.new(
  :jabber_id => 'grepbot@jabber.cc',
  :password => 'tobperg',
  :master    => 'guillaume.riflet@gmail.com',
  :is_public => true
)

# Give your bot a public command
bot.add_command(
  :syntax      => 'rand',
  :description => 'Produce a random number from 0 to 10',
  :regex       => /^rand$/,
  :is_public   => true
) { rand(10).to_s }

# Give your bot a private command with an alias
bot.add_command(
  :syntax      => 'puts <string>',
  :description => 'Write something to $stdout',
  :regex       => /^puts\s+.+$/,
  :alias       => [ 
      :syntax => 'p <string>', 
      :regex => /^p\s+.+$/
  ]
) do |sender, message|
  puts message
  "'#{message}' written to $stdout"
end

bot.add_command(
    :syntax         => 'whereis <name or id>',
    :description    => 'People spotter, give name or id',
    :regex          => /^whereis/i,
    :alias          => [
        :syntax => 'W',
        :regex  => /^K/i
    ],
    :is_public      => true
) do |sender, message|
    #sendreceive("whereis:#{message}")
    "whereis:#{message}"
end

bot.add_command(
   :syntax      => 'kill',
   :description => 'Disconnect me, master.',
   :regex       => /^kill$/,
   :alias       => [
     :syntax => 'K',
     :regex => /^K$/
   ]
) {
  "Ah, you killed me master."
  self.disconnect
}

# Bring your new bot to life
bot.connect

#puts sendreceive("Guillaume\n", 'localhost', 3000)
#puts sendreceive("Guillaume")
