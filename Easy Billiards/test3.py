import cv2
import numpy as np
def nothing(x):
	pass;
im=cv2.imread("/home/karthik/aa.jpg")
im=cv2.cvtColor(im,cv2.COLOR_BGR2GRAY)
#ker=np.ones((5,5),np.uint8)
cv2.namedWindow('im',cv2.WINDOW_NORMAL)
cv2.createTrackbar('R','im',0,255,nothing)
cv2.createTrackbar('G','im',0,255,nothing)
#cv2.namedWindow('j');
#cv2.imshow('j',cv2.Canny(im,100,100));
while(1):
    
    k = cv2.waitKey(0) & 0xFF
    if k == 27:
        break

    # get current positions of four trackbars
    r = cv2.getTrackbarPos('R','im')
    g = cv2.getTrackbarPos('G','im')
    edges = cv2.Canny(im,r,g)
    cv2.imshow('im',edges)
cv2.waitKey(0)
cv2.destroyAllWindows()
