# !/usr/bin/python
import PyQrcodec, sys

# If no arguments were given, print a helpful message
if len(sys.argv)==1:
        print 'Usage: qrdecode imagefile'
        sys.exit(0)

#(i)mage
i=sys.argv[1]

inf, mess = PyQrcodec.decode(i);
print(mess)
