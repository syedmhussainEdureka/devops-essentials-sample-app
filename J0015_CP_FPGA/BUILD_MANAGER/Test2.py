#!\usr\bin\python
import sys
import os
import datetime
import time

print('OS: ', os.name)
#::

print ('Date and time:', datetime.datetime.now())
mydate = datetime.datetime.now()
print mydate.strftime("%A")
print "Or like this: " ,datetime.datetime.now().strftime("%Y-%m-%d-%H-%M")

print('++++++++++++++++++++++++++++++++++++++++++++++++++++')



# print('Number of arguments:', len(sys.argv), 'arguments.')
# print('Argument List:', str(sys.argv))

#if len(sys.argv) == 4:
 # print (help())
   


##print('Argument List:', str(sys.argv)
