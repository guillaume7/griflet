# !/usr/bin/python
import PyQrcodec, sys

#(i)mage
i=sys.argv[1]

# If no arguments were given, print a helpful message
if len(sys.argv)==1:
        print 'Usage: qrdecode imagefile.'
        sys.exit(0)

inf, mess = PyQrcodec.decode(i);
print(mess)
