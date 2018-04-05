%Basic global thresholding
clc;clear;
i=imread(('E:\Coll work\Image processing\ece565-s18-project1\polymersomes.tif'),'tif');
[row1,column1]=size(i);
figure,imshow(i);title('Fig.4b.1 Input Image');
[hist,x]=imhist(i);
figure,imhist(i);title('Fig.4b.2 Histogram of image');
s=row1*column1;
threshold=sum(sum(i))/s; %initial estimate for global threshold 
while true
disp(threshold);
value1=i(i>threshold);value2=i(i<=threshold);
mean1=sum(value1)/length(value1);
mean2=sum(value2)/length(value2);
newthresh=(mean1+mean2)/2;
    if threshold==newthresh
        break;
    else
        threshold=newthresh;
    end
end
i(i<newthresh)=0;i(i>=newthresh)=1;
figure,imshow(i,[]);title('Fig.4b.3 Result of the Global threshold');
