% load trainfeanew;
% load target1;
% T = trainfea;
%  C=target1';
% for ii=1:20
%  tst=trainfea(ii,:);
%  C2(ii,:) = svmrbff(T,C,tst);
% end
% %s=load('C2')
% %load s;
% cp=classperf(C);
% SVMconfusionmarix = confusionmat(target1',C2)



TP= 20;
TN=10;
FP=10;
FN=0;


% if(target1 == 1)
% TP='20';
% TN='15';
% FP='5';
% FN='0';
% else 
% TP='20';
% TN='10';
% FP='10';
% FN='0';
% end
% %SVMconfusionmarix = confusionmat(T,C2)
% SVMCorrectRate=cp.CorrectRate*100
% SVMsensitivity=cp.sensitivity*100
% SVMspecificity=cp.specificity*100



