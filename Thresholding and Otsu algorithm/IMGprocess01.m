%Loading the image
clc;clear;
i=imread(('E:\Coll work\Image processing\ece565-s18-project1\woman.tif'),'tif');
F=fft2(double(i));  %compute the FFT of the image
mag=(abs(F));       %Separating the magnitude and phase part
mag1=fftshift(mag); %To shift the values to the enter
mag1=log(1+mag1);   %Purpose of scaling the values
phase=exp(1i*angle(F));
imag=ifftshift(ifft2((mag))); %Reconstruct the image from magnitude
iphase=ifft2(phase);          %Reconstructing using phase 
inverseff=mag.*exp(-1i*angle(F)); %Reconstruction using conjugate
inverseff1=ifft2(inverseff);
%Image display
figure, imshow((mag1),[]),title('Fig.1.1 Magniture spectrum of original image');
figure,imshow((phase),[]),title('Fig.1.2 Phase spectrum of original image');
figure,imshow(uint8(imag),[]),title('Fig.1.3 Reconstructed image using magnitude');
figure,imshow((iphase),[]),title('Fig.1.4 Reconstructed image using phase');
figure,imshow(i),title('Fig.1.5 original image');
figure,imshow(inverseff1,[]),title('Fig.1.6 Reconstructed image using conjugate');