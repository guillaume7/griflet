#!/usr/bin/env ruby
require 'net/imap'
#require 'mail'

username = 'derbymonsanto.bot@gmail.com'
password = 'gdm12345-'

imap = Net::IMAP.new('imap.gmail.com','993',true)
imap.login(username, password)
imap.select('INBOX')
  imap.search(["NOT", "DELETED"]).each do |message_id|
    envelope = imap.fetch(message_id, "ENVELOPE")[0].attr["ENVELOPE"]
    puts "#{envelope.from[0].name}: \t#{envelope.subject}"
  end
imap.logout()
imap.disconnect()
