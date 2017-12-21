import RPi.GPIO as GPIO
import time
import pygame
import bluetooth
import random
lib=["UP","DOWN"]
def blink(pin):
                GPIO.output(pin,GPIO.LOW)
                time.sleep(0.17)
                GPIO.output(pin,GPIO.HIGH)
                time.sleep(0.17)
                return

def receive():
        server_sock=bluetooth.BluetoothSocket( bluetooth.RFCOMM )

        port = 2
        server_sock.bind(("",port))
        server_sock.listen(1)

        client_sock,address = server_sock.accept()
        print "Accepted connection from ",address

        data = client_sock.recv(1024)
        #print "received [%s]" % data

        client_sock.close()
        server_sock.close()
        return data

def send():
        #bd_addr = receiver
        bd_addr="00:15:83:0C:BF:EB"

        port = 2

        sock=bluetooth.BluetoothSocket( bluetooth.RFCOMM )
        sock.connect((bd_addr, port))
        i=random.randint(0,1)
        initial=lib[i]
        sock.send(initial)
        sock.close()

def neutral():
        GPIO.output(11,1)
        time.sleep(0.0015)
        GPIO.output(11,0)

def up():
        GPIO.output(11,1)
        time.sleep(0.0005)
        GPIO.output(11,0)

def down():
        GPIO.output(11,1)
        time.sleep(0.0025)
        GPIO.output(11,0)

lolol=receive()
bowbow=send()
#if(lolol==bowbow):
#       i=~i
if(lolol!=bowbow):
        print lolol

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

#       lolol=receive()
#       bowbow=send()
        #if(lolol==bowbow):
        #       i=~i
#       if(lolol!=bowbow):
#               print lolol

        if(d>40):
                neutral()
                continue
        if(30<d<40) and (lolol is not None):
                pygame.mixer.music.load("/home/pi/traffic.mp3")
                pygame.mixer.music.play()
                for i in range(0,10):
                        blink(20)
                continue
        if(20<d<30) and (lolol is not None):
                if(lolol=="UP"):
                        pygame.mixer.music.load("/home/pi/climb.mp3")
                        pygame.mixer.music.play()
                        for i in range(0,10):
                                blink(21)
                elif(lolol=="DOWN"):
                        pygame.mixer.music.load("/home/pi/descend.mp3")
                        pygame.mixer.music.play()
                        for i in range(0,10):
                                blink(21)
                continue
        if(d<20)+(lolol is not None):
                if(lolol=="UP"):
                        up()
                if(lolol=="DOWN"):
                        down()
                continue
                