%Edge detection and Thresholding
clc;clear;
im=imread(('E:\Coll work\Image processing\ece565-s18-project1\kidney.tif'),'tif');
figure,imshow(im);title('Fig.2.1 Input Image');
%[Row,Column]=size(im);
padding=zeros(794,690);
padding(3:end-2,3:end-2)=im; %zero padding
[paddedR,paddedC] = size(padding);
paddedTL = (3-1)/2;paddedBR = (3-1)/2;
sobelmask=[-1 -2 -1;0 0 0;1 2 1]; %sobel gradient mask 
outputimage=zeros(paddedR,paddedC);
%	spatial filtering 
for i=3:792
for j=3:688
outputimage(i,j)=sum(sum(padding((i-paddedTL):(i+paddedBR),(j-paddedTL):(j+paddedBR)).* sobelmask));
end
end
outputimage = outputimage(3:end-2,3:end-2);
figure,imshow(outputimage,[]);title('Fig.2.2 Resultant image after Sobel mask');
%[Row1,Column1] = size(outputimage);
padded1=zeros(794,690);
padded1(3:end-2,3:end-2)=outputimage;
[paddedR1,paddedC1] = size(padded1);
padTL1 = (3-1)/2;padBR1 = (3-1)/2;
%smoothingfilter=input('Enter the filter weights as array');
%sm1=sum(smoothingfilter);
%sm2=sum(sm1);
%smoothingfilter=smoothingfilter*(1/sm2); %3*3 smoothing filter
smoothingfilter=[1 1 1;1 1 1;1 1 1]*(1/9);
outputimage1=zeros(paddedR1,paddedC1);
%	spatial filtering 
for i = 3:792
for j = 3:688
outputimage1(i,j)=sum(sum(padded1((i-padTL1):(i+padBR1),(j-padTL1):(j+padBR1)).* smoothingfilter)); 
end
end
outputimage1 = outputimage1(3:end-2,3:end-2);
figure,imshow(outputimage1,[]);title('Fig.2.3 Image after smoothening');
for i=1:size(outputimage1,1)-2
for j=1:size(outputimage1,2)-2
%Sobel mask for x-direction:
Gx=((2*outputimage1(i+2,j+1)+outputimage1(i+2,j)+outputimage1(i+2,j+2))-(2*outputimage1(i,j+1)+outputimage1(i,j)+outputimage1(i,j+2)));
%Sobel mask for y-direction:
Gy=((2*outputimage1(i+1,j+2)+outputimage1(i,j+2)+outputimage1(i+2,j+2))-(2*outputimage1(i+1,j)+outputimage1(i,j)+outputimage1(i+2,j)));
%The gradient of the image
outputimage1(i,j)=sqrt(Gx.^2+Gy.^2);
end
end
figure,imshow(outputimage1,[]);title('Fig.2.4 Gradiation Image' );
outputimage1=uint8(outputimage1);
figure,imhist(outputimage1);title('Fig.2.5 Histogram of Gradiation Image');
Thresh=70;
outputimage1=max(outputimage1,Thresh);
outputimage1(outputimage1==round(Thresh))=0;
figure,imshow(outputimage1,[]);title('Fig.2.6 Image using Edge detection');