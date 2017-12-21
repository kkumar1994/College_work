import cv2
import numpy as np

c=cv2.VideoCapture(1)
while(1):
	ret,frame=c.read();
	hsv=cv2.cvtColor(frame,cv2.COLOR_BGR2HSV)
	lblue=np.array([110,50,50])
	ublue=np.array([130,255,255])
	lg=np.array([50,110,50])
	ug=np.array([255,130,255])
	lr=np.array([50,50,110])
	ur=np.array([255,255,130])
	mask=cv2.inRange(hsv,lblue,ublue)
	mask1=cv2.inRange(hsv,lg,ug)
	mask2=cv2.inRange(hsv,lr,ur)
	res=cv2.bitwise_and(frame,frame,mask=mask)
	res2=cv2.bitwise_and(frame,frame,mask=mask)
	res3=cv2.bitwise_and(frame,frame,mask=mask)
	res=res+res2+res3
	cv2.imshow('frame',frame)
	#cv2.imshow('m',mask)
	cv2.imshow('res',res)
	k=cv2.waitKey(5)&0xFF
	if k==27:
		break
cv2.destroyAllWindows()
