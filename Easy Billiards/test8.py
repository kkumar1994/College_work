import numpy as np
import cv2
image=cv2.imread('/home/karthik/balls');
cv2.imshow('one',image)
imgray = cv2.cvtColor(image,cv2.COLOR_BGR2GRAY)
ret,thresh = cv2.threshold(imgray,100,255,0)
contours, hierarchy = cv2.findContours(thresh,cv2.RETR_TREE,cv2.CHAIN_APPROX_SIMPLE)
mask = np.zeros(imgray.shape,np.uint8)
cv2.imshow('mask',mask)
for h,cnt in enumerate(contours):

    mask = np.zeros(imgray.shape,np.uint8)
    cv2.drawContours(mask,[cnt],0,255,-1)
    mean = cv2.mean(image,mask = mask)
cv2.imshow('hi',image)
cv2.drawContours(image,contours[0],0,(0,255,0),3)
cv2.imshow('imgray',imgray)
cv2.imshow('thresh',thresh)
cv2.imshow('image',image)
cv2.waitKey(0)
