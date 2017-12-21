clear;clc;
input_image=imread('lena_bw_tone.tif');
input_image1=im2double(input_image);
p=input('input order of the filter');

[m,n]=size(input_image1);
for i=1:n
output_yw=aryule(input_image1(i:end),p); 
wht_filt= filter(output_yw,1,input_image1(i:end));
wht_filt1 =vertcat(wht_filt);
end
%display 
figure(1)
imshow(input_image);
title('Input image');
figure(2)
imshow(wht_filt1);
title('Output signal');
