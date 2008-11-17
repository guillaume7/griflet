#!/usr/bin/env ruby
require 'jabber/bot'
require 'grep_file'

#Input: string
#Output is either: 
#       regex + filename
#       regex
#       string 'wrong number of arguments'
#       string 'file doesn't exist'
def split_message_4grep(message)
    items = message.split(/ +/)
    if items.length > 2 || items.length == 0
        msg = "Error: wrong number of arguments: '#{message}'"
        puts msg
        msg
    else
        puts items[0]
        regex = Regexp.new(items[0].gsub(/\//,''))
        puts regex
        if items[1].nil?
            Array.new(regex)
        else
            file = items[1]
            if File.exists? file
                Array.new(regex, file)
            else
                Array.new("File '#{file}' doesn't exist")
            end
        end
    end
end

# Create a public Jabber::Bot
bot = Jabber::Bot.new(
#  :jabber_id => 'grepbott@aol.com', 
#  :password  => 'grtobperg',
  :jabber_id => 'stocks_pointpt@jabber.cc',
  :password => 'oogoog',
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
  :syntax      => 'grep <pattern> <file>',
  :description => 'Search for regex pattern in file.',
  :regex       => /^grep\s+.+/,
  :is_public   => true,
  :alias       => [
      :syntax => 'g <pattern> <file>',
      :regex  => /^g\s+.+/
  ]
) do |sender, message|
    args = split_message_4grep(message)
    puts "Pattern is '#{args[0]}'"
    if args[0].responds_to? :match
        if args[1].nil?
            data = Grepfile.new("yahoofinance.txt")
        else
            data = Grepfile.new(args[1])
        end
        
        reply = data.grep(args[0])

    else
        reply = args[0]
    end

    if reply.nil?
        "WTF is #{message}? Say again?"
    else
        puts reply
        reply.join("\n")
    end

    return reply

end

bot.add_command(
    :syntax         => 'kill',
    :description    => 'Disconnects me, master',
    :regex          => /^kill$/
) do    
    self.disconnect
    puts "The master disconnected me :("
end

# Bring your new bot to life
bot.connect
#arguments = split_message_4grep("GOOG")
#puts arguments[0]
#if arguments[1].nil? 
#    puts grep_file( Regexp.new(arguments[0].gsub(/\//,'')))
#else
#    puts grep_file( Regexp.new(arguments[0].gsub(/\//,'')), arguments[1])
#end
