#Image processing work for shaastra competition
#Author : Adithya Selvaprithiviraj
#Date : 19/12/2014


import numpy as np
import cv2
import getch 
# load the image
image = cv2.imread('o1.jpg')
# cv2.imshow('image',image)

#adjust color thresholds depending on the light ! below works for almost all cases
boundaries = [
        ([0, 0, 140], [140, 140, 255]),
        ([140, 0, 0], [255, 165, 150]),
        ([0, 146, 190], [140, 255, 255]),
        ([10, 90,10], [140, 255, 140]),
        ]
bn=1
full_y=[]
full_x=[]

red=[]
blue=[]
yellow=[]
green=[]


red1=[]
blue1=[]
yellow1=[]
green1=[]

full_x1=[]
full_y1=[]

for (lower, upper) in boundaries:
    # create NumPy arrays from the boundaries
    lower = np.array(lower, dtype = "uint8")
    upper = np.array(upper, dtype = "uint8")

    # find the colors within the specified boundaries and apply
    # the mask
    mask = cv2.inRange(image, lower, upper)
    output = cv2.bitwise_and(image, image, mask = mask)
    
    mask =cv2.medianBlur(mask,5) 
    (cnts, _) = cv2.findContours(mask.copy(), cv2.RETR_EXTERNAL,cv2.CHAIN_APPROX_SIMPLE)
    cv2.imshow("images",mask)
    cv2.waitKey(0)
    for c in cnts:
        cv2.drawContours(image, [c], -1, (0, 255, 0), 2)
        # print c
        # c.sort()
        if cv2.contourArea(c)>4600:  #adjust threshold depending on the image
            # print "box" + str(bn)
            # print c[1]
            dum1=[]
            dum2=[]
            for i in c:
                dum1.append(i[0][0])
                dum2.append(i[0][1])
            dum1.sort()
            dum2.sort()
            # print dum1[0],dum2[0]
            # print dum1[len(dum1)-1],dum2[len(dum2)-1]
            full_y.append(dum1[0])
            full_x.append(dum2[0])
            full_y1.append(dum1[len(dum1)-1])
            full_x1.append(dum2[len(dum2)-1])
            
            temp1=[dum1[len(dum1)-1],dum2[len(dum2)-1]] 
            temp=[dum1[0],dum2[0]]

            if bn==1:
                red.append(temp)
                red1.append(temp1)
            elif bn==2:
                blue.append(temp)
                blue1.append(temp1)
            elif bn==3:
                yellow.append(temp)
                yellow1.append(temp1)
            else:
                green.append(temp)
                green1.append(temp1)
            
        cv2.imshow("Image", image)
        cv2.waitKey(0)
    bn +=1
full_x.sort()
full_y.sort()

# print ful_x
# print full_y
#
# print red
# print blue
# print yellow
# print green

print red1
print blue1
print yellow1
print green1

if len(full_x)<16:
    print "Adjust the color boundaries to capture all 16 boxes"
    exit()

hash1=range(full_x[3]-20,full_x[3]+20)
hash2=range(full_x[7]-20,full_x[7]+20)
hash3=range(full_x[11]-20,full_x[11]+20)
hash4=range(full_x[15]-20,full_x[15]+20)

log1={}
log2={}
log3={}
log4={}

for i in red:
    if i[1] in hash1:
        log1[i[0]]=1
    elif i[1] in hash2:
        log2[i[0]]=1
    elif i[1] in hash3:
        log3[i[0]]=1
    else :
        log4[i[0]]=1

for i in blue:
    if i[1] in hash1:
        log1[i[0]]=2
    elif i[1] in hash2:
        log2[i[0]]=2
    elif i[1] in hash3:
        log3[i[0]]=2
    else :
        log4[i[0]]=2


for i in yellow:
    if i[1] in hash1:
        log1[i[0]]=3
    elif i[1] in hash2:
        log2[i[0]]=3
    elif i[1] in hash3:
        log3[i[0]]=3
    else :
        log4[i[0]]=3

for i in green:
    if i[1] in hash1:
        log1[i[0]]=4
    elif i[1] in hash2:
        log2[i[0]]=4
    elif i[1] in hash3:
        log3[i[0]]=4
    else :
        log4[i[0]]=4

# print log1
# print log2
# print log3
# print log4

log1key=log1.keys()
log2key=log2.keys()
log3key=log3.keys()
log4key=log4.keys()

log1key.sort()
log2key.sort()
log3key.sort()
log4key.sort()

colormatrix=[]
colormatrix.append([])
colormatrix.append([])
colormatrix.append([])
colormatrix.append([])

for keys in log1key:
    colormatrix[0].append(log1[keys])

for keys in log2key:
    colormatrix[1].append(log2[keys])

for keys in log3key:
    colormatrix[2].append(log3[keys])

for keys in log4key:
    colormatrix[3].append(log4[keys])

for i in range(4):
    print colormatrix[i]


print "LEGEND:\n1=RED\n2=BLUE\n3=YELLOW\n4=GREEN"
