#!/usr/bin/python
import libgmail

#ga = libgmail.GmailAccount("derbymonsanto.bot@gmail.com", "gdm12345-")
ga = libgmail.GmailAccount("guillaume.riflet@gmail.com", "qwerty12345-")
ga.login()
folder = ga.getMessagesByFolder('inbox')

for thread in folder:
    print thread.id, len(thread), thread.subject
    for msg in thread:
        print "  ", msg.id, msg.number, msg.subject
        print msg.sourcerequire 
