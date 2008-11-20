#!/usr/bin/env ruby
require 'jabber/bot'
require 'socket'
require 'date'

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

def timefromnow(string)
    now = DateTime.now
    date = DateTime.parse(string)
    days = (now-date).to_f
    secs = days * 86400
    if secs < 60
        msg = secs.to_i + " seconds ago."
    else
        if secs > 59 && secs < 120
            msg = "1 minute ago."
        else
            mins = secs / 60
            if mins < 60
                msg = mins.to_i.to_s + " minutes ago."
            else
                if mins > 59 && mins < 120
                    msg = "1 hour ago."
                else
                    hours = mins / 60
                    if hours < 24
                        msg = hours.to_i.to_s + " hours ago."
                    else
                        if hours > 23 && hours < 48
                            msg = "1 day ago."
                        else
                            days = hours / 24
                            msg = days.to_i.to_s + " days ago."
                        end
                    end
                end
            end
        end
    end

    return msg

end

class Rfidcodebits

    def initialize(file = "rfidbits.txt")
        @cache = file
        @results = Array.new
    end

    def whereis(message)

        flag = false
        File.open(@cache,'r') { |fs|
            pat=message.gsub(/ /,' .*')
            while line = fs.gets
                words = line.split(/\|/)
                if words[5].match(/#{pat}/i) || words[2].match(/^#{message.strip}$/)
                    flag = true
                    @results.push("#{words[5]} (#{words[2]}) was last seen at " + words[1] + ", " + timefromnow(words[3]))
                end
            end
            fs.close
            if !flag 
                @results.push("#{message} wasn't found.")
            end
            @results
        }

    end

end

# Create a public Jabber::Bot
bot = Jabber::Bot.new(
  :jabber_id => 'codebits@jabber.cc',
  :password => 'hackathon',
  :master    => 'guillaume.riflet@gmail.com',
  :is_public => true
)

# Give your bot a public command
bot.add_command(
  :syntax      => 'rand',
  :description => 'Produce a random number from 0 to 10',
  :regex       => /^rand$/,
  :is_public   => false
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
    :regex          => /^whereis */i,
    :alias          => [
        :syntax => 'W',
        :regex  => /^W */i
    ],
    :is_public      => true
) do |sender, message|
    #sendreceive("whereis:#{message}")
    bits = Rfidcodebits.new 
    bits.whereis(message).join("\n\n")
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
begin
  bot.connect
rescue
  puts "The bot got, somehow, disconnected."
end

#puts sendreceive("Guillaume\n", 'localhost', 3000)
#puts sendreceive("Guillaume")

#mybits = Rfidcodebits.new
#puts mybits.whereis(" 32 ").join("\n")
#puts timefromnow('2008-11-14 17:18:46')
