#!\usr\bin\python
import sys
import os
import datetime
import time

DBG='D'

def my_print(param1, param2):
   if DBG=="D":
      print(param1, param2)
      return

print('OS: ', os.name)
#::
strTime=datetime.datetime.now()

# print('Number of arguments:', len(sys.argv), 'arguments.')
# print('Argument List:', str(sys.argv))

#if len(sys.argv) == 4:
 # print (help())
   
finTime=datetime.datetime.now()

my_print("Start Time: " , strTime.strftime("%Y-%m-%d-%H-%M"))
print("Finish Time: " , finTime.strftime("%Y-%m-%d-%H-%M"))

##print('Argument List:', str(sys.argv)