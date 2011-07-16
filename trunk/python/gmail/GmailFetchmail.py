#!/usr/bin/env python
# 
# $Id: GmailFetchmail.py,v 1.4 2010/02/08 00:03:50 solovam Exp $
#

#@PydevCodeAnalysisIgnore

import sys
import subprocess
import syslog
import traceback
import time
import re
import libgmail

class GmailFetchmail:
	
	IDENT = 'GmailFetchmail'
	SENDMAIL_CMD = ['/usr/sbin/sendmail', '-i', '--']
	INBOX_MAILBOX_NAME = 'inbox'

	def __init__(self, username, password, localUsername, domain = None):
		self._username = username
		self._password = password
		self._localUsername = localUsername
		self._gmailAccount = libgmail.GmailAccount(name = self._username, pw = self._password, domain = domain)	
		self._gmailAccount.login()
		self._sendmailCommand = GmailFetchmail.SENDMAIL_CMD
		self._sendmailCommand.append(self._localUsername)
	
	def initLog():
		syslog.openlog(GmailFetchmail.IDENT,  syslog.LOG_CONS | syslog.LOG_NOWAIT | syslog.LOG_PID, syslog.LOG_USER)
	initLog = staticmethod(initLog)
		
	def closeLog():
		syslog.closelog()
	closeLog = staticmethod(closeLog)
		
	def log(priority, message):
		syslog.syslog(priority, message)
		#print '%s %s: %s' % (time.time(), GmailFetchmail.IDENT, message)
	log = staticmethod(log)
	
	def fetch(self, folderName):
		GmailFetchmail.log(syslog.LOG_INFO, 'fetching messages for folder: %s' % folderName)
			
		folder = self._gmailAccount.getMessagesByFolder(folderName)
			
		for thread in folder:			
			GmailFetchmail.log(syslog.LOG_INFO, 'thread, id: %s, length: %s, subject: %s' % (thread.id, len(thread), repr(thread.subject)))
			
			for message in thread:
				GmailFetchmail.log(syslog.LOG_INFO, 'message, id: %s, number: %s, subject: %s' % (message.id, message.number, repr(message.subject)))
				
				res = self._feedMessageToSendmail(message.source)
				
				if res == 0:
					GmailFetchmail.log(syslog.LOG_INFO, 'removing message, id: %s' % message.id)
					
					self._gmailAccount.trashMessage(message)
			
	def _feedMessageToSendmail(self, message):
	
		GmailFetchmail.log(syslog.LOG_INFO, 'opening sendmail pipe')
		
		message = re.sub('^\s+', '', message, re.S)
		
		popen = subprocess.Popen(self._sendmailCommand, stdin = subprocess.PIPE)
		
		popen.communicate(message)
		
		res = popen.returncode
		
		GmailFetchmail.log(syslog.LOG_INFO, 'sendmail return code: %s' % res)
		
		return res
	
	def main(username, password, localUsername, domain = None):
		try:
			GmailFetchmail.initLog()
	
			gmailFetchmail = GmailFetchmail(username, password, localUsername, domain)
			
			gmailFetchmail.fetch(GmailFetchmail.INBOX_MAILBOX_NAME)
			
		except:
			GmailFetchmail.log(syslog.LOG_ERR, 'exception in main(): %s' % traceback.format_exc())
	main = staticmethod(main)

if __name__ == '__main__':

	username = sys.argv[1]
	password = sys.argv[2]
	localUsername = sys.argv[3]
	domain = None
	if len(sys.argv) > 4:
		domain = sys.argv[4]
	
	GmailFetchmail.main(username, password, localUsername, domain)