import cv2
import numpy as np
image=cv2.imread('/home/karthik/aa.jpg');
cv2.namedWindow("image",cv2.WINDOW_AUTOSIZE);
cv2.imshow("image",image);
kernel=np.ones((5,5),np.float32)/25;
img=cv2.filter2D(image,-1,kernel);
cv2.namedWindow('img',cv2.WINDOW_AUTOSIZE);
cv2.imshow('img',img);
i=cv2.bilateralFilter(image,9,100,100)
cv2.namedWindow('i');
cv2.imshow('i',i);
cv2.waitKey(0)

