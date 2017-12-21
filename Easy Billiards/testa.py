import cv2
import numpy as np

image=cv2.imread("hi.jpg")

image=image[100:310,50:410]#cropping

cv2.imshow('image',image)

l = np.array([0,60,0]) #green range

u = np.array([100,255,100])

maskgreen=cv2.inRange(image,l,u)

kernel = np.ones((5,5),np.uint8)

maskgreen2= cv2.morphologyEx(maskgreen, cv2.MORPH_CLOSE, kernel)

output1=cv2.bitwise_and(image, image, mask=cv2.bitwise_not(maskgreen2)) #after green mask

lw = np.array([180,180,200]) #white range

uw = np.array([255,255,255])

maskwhite=cv2.inRange(image,lw,uw)

output2=cv2.bitwise_and(image,image,mask=maskwhite) #after white mask

cv2.imshow('output2b',output2)

output2=cv2.cvtColor(output2,cv2.COLOR_BGR2GRAY)

_,threshold=cv2.threshold(output2,195,255,0) 

cv2.imshow('threshold',threshold)

contour,hie=cv2.findContours(threshold,cv2.RETR_TREE,cv2.CHAIN_APPROX_SIMPLE) #find contour

print contour[100]

for n in range(50,100):

	cv2.drawContours(output1,contour[n],-1,(255,0,255),1) #draw contour

cv2.imshow('output2',output2)

cv2.imshow('maskwhite',maskwhite)

cv2.imshow('maskgreen',maskgreen)

cv2.imshow('output1',output1)

cv2.waitKey(0)
