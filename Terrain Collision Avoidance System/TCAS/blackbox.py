import time
from time import sleep,strftime
import Adafruit_BMP.BMP085 as BMP085
sensor = BMP085.BMP085()

while(True):
	t=(sensor.read_temperature())
	p=(sensor.read_pressure())
	h=(sensor.read_altitude())
	f=open("blackbox.txt",'a')
	now=strftime("%D:%H:%M:%S")
	f.write("At time"+ str(now) + "The temperature  was" +str(t) + "*C" + " The altitude was" + str(h) + "m" + "the pressure was" + str(p) + "Pa" + "\n")
	time.sleep(2)
	f.close()
