trainfeanew=zeros(20,5);for ii=1:20I=imread(['Dataset\',num2str(ii),'.jpg']);figure(1),imshow(I);title('Original image');[r c m]=size(I);GLCM2 = graycomatrix(I,'Offset',[0,1]);stats1 = graycoprops(GLCM2,{'contrast','homogeneity','correlation','energy'})testfea(1,1)=getfield(stats1,'Contrast');testfea(1,2)=getfield(stats1,'Homogeneity');testfea(1,3)=getfield(stats1,'Correlation');testfea(1,4)=getfield(stats1,'Energy');testfea(1,5)=entropy(GLCM2);trainfeanew(ii,1:5)=[testfea];endsave trainfeanew trainfeanew