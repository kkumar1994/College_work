%Global thresholding
clc;clear;
i=imread(('E:\Coll work\Image processing\ece565-s18-project1\noisy_fingerprint.tif'),'tif'); 
figure,imshow(i);title('Fig.3.1 original image');
[hist,x]=imhist(i);
figure,imhist(i);title('Fig.3.2 histogram');
T=150; %initial estimate for global threshold 
while true
disp(T);
value1=i(i>T);value2=i(i<=T);
mean1=sum(value1)/length(value1);mean2=sum(value2)/length(value2);
newthresh=(mean1+mean2)/2;
    if T==newthresh
        break;
    else
        T=newthresh;
    end
end
i(i<newthresh)=0;i(i>=newthresh)=1;
figure,imshow(i,[]);title('Fig.3.3 Segmented result using a global threshold');
 
