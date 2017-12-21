import RPi.GPIO as GPIO
import time
import pygame
def blink(pin):
                GPIO.output(pin,GPIO.LOW)
                time.sleep(0.17)
                GPIO.output(pin,GPIO.HIGH)
                time.sleep(0.17)
                return

while(True):
	GPIO.setmode(GPIO.BCM)
	GPIO.setwarnings(False)
	pygame.mixer.init()
	GPIO.setup(20,GPIO.OUT)
	GPIO.setup(21,GPIO.OUT)
	GPIO.setup(11,GPIO.OUT)
	TRIG = 23
	ECHO = 24
	print"DM in progress"
	GPIO.setup(TRIG,GPIO.OUT)
	GPIO.setup(ECHO,GPIO.IN)
	GPIO.output(TRIG,False)
	print"Waiting for sensor to settle"
	time.sleep(2)
	GPIO.output(TRIG,True)
	time.sleep(0.00001)
	GPIO.output(TRIG,False)
	while GPIO.input(ECHO)==0:
		pulse_start = time.time()
	while GPIO.input(ECHO)==1:
		pulse_end=time.time()
	pulse_duration=pulse_end-pulse_start
	d=pulse_duration*17150
	d=round(d,2)
	print d,"cm"
		
	if(d>40):
		GPIO.output(11,1)
		time.sleep(0.0015)
		GPIO.output(11,0)
		continue
	if(30<d<40):
		pygame.mixer.music.load("/home/pi/terrain.mp3")
		pygame.mixer.music.play()
		for i in range(0,10):
			blink(20)
		continue
	if(20<d<30):
		pygame.mixer.music.load("/home/pi/terrain ahead pull up.mp3")
		pygame.mixer.music.play()
		for i in range(0,10):
			blink(21)
		continue
		
	if(d<20):
		GPIO.output(11,1)
		time.sleep(0.0025)
		GPIO.output(11,0)
		continue
