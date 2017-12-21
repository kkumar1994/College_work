import cv2
import numpy as np
image=cv2.imread("/home/karthik/Index")
image=cv2.cvtColor(image,cv2.COLOR_BGR2GRAY)
cv2.namedWindow("image",cv2.WINDOW_NORMAL)

image=cv2.bilateralFilter(image,1,100,100)
#ret,image=cv2.threshold(image,10,255,cv2.THRESH_BINARY)
#for i in range(0,200):
	#for j in range(0,100):
		#print i
image=cv2.Canny(image,100,200)
cv2.imshow("image",image)
cv2.waitKey(0)	

#image=cv2.Canny(image,10,200)


