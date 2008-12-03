#!/usr/bin/env ruby
require 'jabber/bot'
require 'grep_file'

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

  data = Grepfile.new
  data.extractinput(message)
  data.grepit.join("\n")

end

bot.add_command(
  :syntax      => 'stock <sticker>',
  :description => 'Return the latest stock quote',
  :regex       => /^stock\s+.+/,
  :is_public   => true,
  :alias       => [
      :syntax => 's <sticker>',
      :regex  => /^s\s+.+/
  ]
) do |sender, message|

  data = Grepstock.new
  data.stockinfo(message)

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

