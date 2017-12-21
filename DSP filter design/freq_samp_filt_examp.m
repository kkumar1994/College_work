function [h,H,w] = freq_samp_filt_examp(M,BW,TBW,alpha)
% Frequency sampling filter example:  we generate an M-length filter design
% of a lowpass filter whose bandwidth is BW frequency samples and whose
% transition bandwith is TBW frequency samples.  The magnitude of the
% response in the frequency samples must be specified in vector alpha.
%
% input values:
%   M:      filter length
%   BW:     filter bandwidth (in frequency samples)
%   TBW:    transition bandwidth (in frequency samples)
%   alpha:  magnitude response in the transition band
%
% output values:
%   h:      filter coefficients of the design
%   H:      frequency response values 
%   w:    frequency values at which H was computed


%M = 31;
%BW = 5;
%TBW = 2;
%alpha = [0.7 ; 0.3];

w_k1 = ((2*pi)/M)*[1:BW+TBW-1]';

Hd_1 = [ones(BW-1,1) ; alpha.*ones(TBW,1) ] .* exp(-j*((M-1)/2)*w_k1);
Hd_2 = conj(flipud(Hd_1));
Hd = [1 ; Hd_1 ; zeros(M-2*length(Hd_1)-1,1) ; Hd_2 ] ;
h = ifft(Hd);

real_check = norm(h-real(h))

Hdmag_1 = [ones(BW-1,1) ; alpha.*ones(TBW,1) ] ;
Hdmag_2 = conj(flipud(Hdmag_1));
Hdmag = [1 ; Hdmag_1 ; zeros(M-2*length(Hdmag_1)-1,1) ; Hdmag_2 ] ;
k = 0:M-1;
% 
% figure(1)
% stem(k,Hdmag)
% xlabel('freq index k')
% ylabel('|H_d(2\pi k/(M-1))|')
% title('Desired magnitude response')
% 
% figure(2)
% stem(real(h)),xlabel('sample n'),ylabel('h(n)')
% title('Frequency sampling filter impulse response')

numpoints = 1024;
[H,w]=freqz(h,1,numpoints);
% % figure(3)
% % plot(w,abs(H),'-',2*pi*[0:floor((M+1)/2)-1]'/M,abs(Hd(1:floor((M+1)/2))),'o','LineWidth',2)
% % xlabel('freq \omega (rad/sample)'), ylabel('|H(\omega)|')
% % title(['Freq. samp. filt. resp.: M = ',num2str(M),', BW = ',num2str(BW)])
% 
% if TBW==1,
%     figure(4)
%     semilogy(w,abs(H),'-',2*pi*[0:floor((M+1)/2)-1]'/M,abs(Hd(1:floor((M+1)/2))),'o','LineWidth',2)
%     xlabel('freq \omega (rad/sample)'), ylabel('|H(\omega)|')
%     title(['Freq. samp. filt. resp.: M = ',num2str(M),', BW = ',num2str(BW),', \alpha = ',num2str(alpha(1))])
% end
% 
% if TBW==2,
%     figure(4)
%     semilogy(w,abs(H),'-',2*pi*[0:floor((M+1)/2)-1]'/M,abs(Hd(1:floor((M+1)/2))),'o','LineWidth',2)
%     xlabel('freq \omega (rad/sample)'), ylabel('|H(\omega)|')
%     title(['Freq. samp. filt. resp.: M = ',num2str(M),', BW = ',num2str(BW),', \alpha_1 = ',num2str(alpha(1)),', \alpha_2 = ',num2str(alpha(2))])
% end


% print; close
% print; close
% print; close
