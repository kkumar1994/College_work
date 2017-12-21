import cv2
import numpy as np

image=cv2.imread("hi.jpg")

image=image[100:310,50:410]#cropping

cv2.imshow('image',image)

l = np.array([0,60,0]) #green range

u = np.array([100,255,110])
maskgreen=cv2.inRange(image,l,u)
kernel = np.ones((5,5),np.uint8)
res1= cv2.morphologyEx(maskgreen, cv2.MORPH_CLOSE, kernel)
maski=cv2.bitwise_and(image, image, mask=cv2.bitwise_not(res1))
lw = np.array([140,140,140]) #white range
uw = np.array([255,255,255])
maskwhite=cv2.inRange(image,lw,uw)
maski2=cv2.bitwise_and(image, image, mask=maskwhite)
res2= cv2.morphologyEx(maski2, cv2.MORPH_CLOSE, kernel)
cv2.imshow('maskwhite',res2)
cv2.imshow('maski2',maski2)
#mean=cv2.medianBlur(mask,5)
cv2.imshow('maskgreen',res1)
cv2.imshow('maski',maski)
# cv2.imshow('maski',maski)
# image1=cv2.bitwise_and(image,image,mask=mask)
# image2=cv2.bitwise_and(image,image,mask=maski)
# #image2=cv2.bitwise_and(image2,image,mask=mask)
# res=cv2.add(image1,image2,mask=mask)
# #res = cv2.cvtColor(res, cv2.COLOR_BGR2GRAY)

# res2=cv2.bitwise_and(res1,res1,mask=maski)
# #cv2.imshow('mask1',mask1)
# res2=cv2.add(res1,res2)
res3=cv2.cvtColor(res2,cv2.COLOR_BGR2GRAY)
cv2.imshow('res3',res3)
# #res1= cv2.equalizeHist(res1)
# #ret,thresh=cv2.threshold(res3,100,255,0)
# #contour,hie=cv2.findContours(thresh,cv2.RETR_TREE,cv2.CHAIN_APPROX_SIMPLE)
# #print len(contour)
# #cv2.drawContours(res3,contour,-1,(0,255,0),3)
ret,thresh = cv2.threshold(res3,230,255,cv2.THRESH_BINARY_INV)
cv2.imshow('thresh',cv2.bitwise_not(thresh))
contours, hierarchy = cv2.findContours(thresh,cv2.RETR_TREE,cv2.CHAIN_APPROX_SIMPLE)
print len(contours)
mask = np.zeros(res3.shape,np.uint8)
cv2.imshow('mask',mask)
for h,cnt in enumerate(contours):
   
     
     cv2.drawContours(image,[cnt],0,255,-1)
     #mean = cv2.mean(image,mask = mask)
cv2.drawContours(image,contours,-1,(0,0,0),3)
#cv2.imshow('img1',image1)
#cv2.imshow('img2',image2)
#cv2.imshow('res',res)
#cv2.imshow('res1',res1)
#cv2.imshow('thresh',thresh)
#cv2.imshow('res3',res2)
cv2.imshow('newimage',image)
cv2.waitKey(0)
