# !/usr/bin/python
import PyQrcodec, sys

# If no arguments were given, print a helpful message
if len(sys.argv)==1:
        print 'Usage: qrencode "message" filename'
        sys.exit(0)

#(m)essage and (f)ilename
m=sys.argv[1]
f=sys.argv[2]

size, image = PyQrcodec.encode(m)
image.save(f)
