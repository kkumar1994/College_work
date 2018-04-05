%Otsu’s optimum thresholding
clc;clear;
I=imread(('E:\Coll work\Image processing\ece565-s18-project1\polymersomes.tif'),'tif'); 
figure,imshow(I);title('Fig.4a.1 Original Image');
[hist,x]=imhist(I);
figure,imhist(I);title('Fig.4a.2 Histogram of image');
threshold=256;
counts=imhist(I,threshold);
mean=counts / sum(counts);
mean1=0;mean2=0;mu1=0;
for t=1:threshold
mean1(t)=sum(mean(1:t));
mean2(t)=sum(mean(t+1:end));
mu1(t)=sum(mean(1:t).*(1:t)');
end
sigma =(mu1(end).*mean1-mu1).^2./(mean1.*(1-mean1));
[row,column]=max(sigma);
I(I<column)=0;I(I>=column)=1;
figure,imshow(I,[]);title('Fig.4a.3 Otsu method output');
