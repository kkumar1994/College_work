% FIR filter design via windowing methods

% Select the cutoff w_c
wc = 1/5*pi;
% Select the number of frequency response points to calculate
% when determining the responses
numpoints = 4096;



% PROCESS FOR M=31

M=25;
%M=15;
%wc =0.4*pi;
n = 0:(M-1);

% Generate windows
rectangular = ones(1,M) ;
bartlett = 1 - 2*abs(n - (M-1)/2)/(M-1) ;
hamming = 0.54 - 0.46*cos(2*pi*n/(M-1));
hanning = 0.5*(1-cos(2*pi*n/(M-1)));

[Hr,w]=freqz(rectangular,1,numpoints);
[Hb,w]=freqz(bartlett,1,numpoints);
[Hhm,w]=freqz(hamming,1,numpoints);
[Hhn,w]=freqz(hanning,1,numpoints);

figure(1),subplot(111),plot(w/pi,abs(Hr),'-',w/pi,abs(Hb),'--',...
   w/pi,abs(Hhm),':',w/pi,abs(Hhn),'-.','Linewidth',2)
legend('Rectangular','Triangular','Hamming','Hanning')
axis([xlim 0 100])
xlabel('normalized frequency (\times\pi rad./sample)')
ylabel('magnitude')
title(['H(\omega), M=',num2str(M)])




figure(1),subplot(111),plot(w/pi,abs(Hr),'-',w/pi,abs(Hb),'--',...
   w/pi,abs(Hhm),':',w/pi,abs(Hhn),'-.','Linewidth',2)
legend('Rectangular','Triangular','Hamming','Hanning')
axis([xlim 0 100])
xlabel('normalized frequency (\times\pi rad./sample)')
ylabel('magnitude')
title(['H(\omega), M=',num2str(M)])

figure(2),subplot(111),plot(w/pi,abs(Hr),'-',w/pi,abs(Hb),'--',...
   w/pi,abs(Hhm),':',w/pi,abs(Hhn),'-.','Linewidth',2)
legend('Rectangular','Triangular','Hamming','Hanning')
axis([xlim 0 40])
xlabel('normalized frequency (\times\pi rad./sample)')
ylabel('magnitude')
title(['H(\omega), M=',num2str(M)])

% Generate impulse response
h = sin( wc*(n-(M-1)/2) ) ./ (pi*(n-(M-1)/2)) ;
if (M/2)~=ceil(M/2),h((M+1)/2) = wc/pi ; end

[Hr,w]=freqz(rectangular.*h,1,numpoints);
[Hb,w]=freqz(bartlett.*h,1,numpoints);
[Hhm,w]=freqz(hamming.*h,1,numpoints);
[Hhn,w]=freqz(hanning.*h,1,numpoints);

w31=w;
Hr31=Hr;
Hb31=Hb;
Hhm31=Hhm;
Hhn31=Hhn;

figure(3),subplot(111),plot(w/pi,abs(Hr),'-',w/pi,abs(Hb),'--',...
   w/pi,abs(Hhm),':',w/pi,abs(Hhn),'-.','Linewidth',2)
legend('Rectangular','Triangular','Hamming','Hanning')
axis([xlim 0 1.2])
grid
xlabel('normalized frequency (\times\pi rad./sample)')
ylabel('magnitude')
title(['H(\omega), M=',num2str(M)])

figure(4),subplot(111),plot(w/pi,20*log10(abs(Hr)),'-',w/pi,...
   20*log10(abs(Hb)),'--',w/pi,20*log10(abs(Hhm)),':',w/pi,...
   20*log10(abs(Hhn)),'-.','Linewidth',2)
legend('Rectangular','Triangular','Hamming','Hanning')
%axis([xlim -200 20])
grid
xlabel('normalized frequency (\times\pi rad./sample)')
ylabel('magnitude')
title(['H(\omega), M=',num2str(M)])

% PROCESS FOR M=61

M=61;
n = 0:(M-1);

% Generate windows
rectangular = ones(1,M) ;
bartlett = 1 - 2*abs(n - (M-1)/2)/(M-1) ;
hamming = 0.54 - 0.46*cos(2*pi*n/(M-1));
hanning = 0.5*(1-cos(2*pi*n/(M-1)));

[Hr,w]=freqz(rectangular,1,numpoints);
[Hb,w]=freqz(bartlett,1,numpoints);
[Hhm,w]=freqz(hamming,1,numpoints);
[Hhn,w]=freqz(hanning,1,numpoints);

figure(5),subplot(111),plot(w/pi,abs(Hr),'-',w/pi,abs(Hb),'--',...
   w/pi,abs(Hhm),':',w/pi,abs(Hhn),'-.','Linewidth',2)
legend('Rectangular','Triangular','Hamming','Hanning')
axis([xlim 0 100])
xlabel('normalized frequency (\times\pi rad./sample)')
ylabel('magnitude')
title(['H(\omega), M=',num2str(M)])

% Generate impulse response
h = sin( wc*(n-(M-1)/2) ) ./ (pi*(n-(M-1)/2)) ;
if (M/2)~=ceil(M/2),h((M+1)/2) = wc/pi ; end

[Hr,w]=freqz(rectangular.*h,1,numpoints);
[Hb,w]=freqz(bartlett.*h,1,numpoints);
[Hhm,w]=freqz(hamming.*h,1,numpoints);
[Hhn,w]=freqz(hanning.*h,1,numpoints);

w61=w;
Hr61=Hr;
Hb61=Hb;
Hhm61=Hhm;
Hhn61=Hhn;

figure(6),subplot(111),plot(w/pi,abs(Hr),'-',w/pi,abs(Hb),'--',...
   w/pi,abs(Hhm),':',w/pi,abs(Hhn),'-.','Linewidth',2)
legend('Rectangular','Triangular','Hamming','Hanning')
axis([xlim 0 1.2])
grid
xlabel('normalized frequency (\times\pi rad./sample)')
ylabel('magnitude')
title(['H(\omega), M=',num2str(M)])

figure(7),subplot(111),plot(w/pi,20*log10(abs(Hr)),'-',w/pi,...
   20*log10(abs(Hb)),'--',w/pi,20*log10(abs(Hhm)),':',w/pi,...
   20*log10(abs(Hhn)),'-.','Linewidth',2)
legend('Rectangular','Triangular','Hamming','Hanning')
%axis([xlim -200 20])
grid
xlabel('normalized frequency (\times\pi rad./sample)')
ylabel('magnitude')
title(['H(\omega), M=',num2str(M)])

% PROCESS FOR M=91

M=91;
n = 0:(M-1);

% Generate windows
rectangular = ones(1,M) ;
bartlett = 1 - 2*abs(n - (M-1)/2)/(M-1) ;
hamming = 0.54 - 0.46*cos(2*pi*n/(M-1));
hanning = 0.5*(1-cos(2*pi*n/(M-1)));

[Hr,w]=freqz(rectangular,1,numpoints);
[Hb,w]=freqz(bartlett,1,numpoints);
[Hhm,w]=freqz(hamming,1,numpoints);
[Hhn,w]=freqz(hanning,1,numpoints);

figure(8),subplot(111),plot(w/pi,abs(Hr),'-',w/pi,abs(Hb),'--',...
   w/pi,abs(Hhm),':',w/pi,abs(Hhn),'-.','Linewidth',2)
legend('Rectangular','Triangular','Hamming','Hanning')
axis([xlim 0 100])
xlabel('normalized frequency (\times\pi rad./sample)')
ylabel('magnitude')
title(['H(\omega), M=',num2str(M)])

% Generate impulse response
h = sin( wc*(n-(M-1)/2) ) ./ (pi*(n-(M-1)/2)) ;
if (M/2)~=ceil(M/2),h((M+1)/2) = wc/pi ; end

[Hr,w]=freqz(rectangular.*h,1,numpoints);
[Hb,w]=freqz(bartlett.*h,1,numpoints);
[Hhm,w]=freqz(hamming.*h,1,numpoints);
[Hhn,w]=freqz(hanning.*h,1,numpoints);

w91=w;
Hr91=Hr;
Hb91=Hb;
Hhm91=Hhm;
Hhn91=Hhn;

figure(9),subplot(111),plot(w/pi,abs(Hr),'-',w/pi,abs(Hb),'--',...
   w/pi,abs(Hhm),':',w/pi,abs(Hhn),'-.','Linewidth',2)
legend('Rectangular','Triangular','Hamming','Hanning')
axis([xlim 0 1.2])
grid
xlabel('normalized frequency (\times\pi rad./sample)')
ylabel('magnitude')
title(['H(\omega), M=',num2str(M)])

figure(10),subplot(111),plot(w/pi,20*log10(abs(Hr)),'-',w/pi,...
   20*log10(abs(Hb)),'--',w/pi,20*log10(abs(Hhm)),':',w/pi,...
   20*log10(abs(Hhn)),'-.','Linewidth',2)
legend('Rectangular','Triangular','Hamming','Hanning')
%axis([xlim -200 20])
grid
xlabel('normalized frequency (\times\pi rad./sample)')
ylabel('magnitude')
title(['H(\omega), M=',num2str(M)])

figure(11),subplot(111),plot(w/pi,(abs(Hr31)),'-',w/pi,...
   (abs(Hr61)),'--',w/pi,(abs(Hr91)),':','Linewidth',2)
legend('M=31','M=61','M=91')
%axis([xlim -200 20])
grid
xlabel('normalized frequency (\times\pi rad./sample)')
ylabel('magnitude')
title('H(\omega), rectangular window')

figure(12),subplot(111),plot(w/pi,20*log10(abs(Hr31)),'-',...
   w/pi,20*log10(abs(Hr61)),'--',w/pi,20*log10(abs(Hr91)),':','Linewidth',2)
legend('M=31','M=61','M=91')
%axis([xlim -200 20])
grid
xlabel('normalized frequency (\times\pi rad./sample)')
ylabel('magnitude')
title('H(\omega), rectangular window')

figure(13),subplot(111),plot(w/pi,20*log10(abs(Hhm31)),'-',...
   w/pi,20*log10(abs(Hhm61)),'--',w/pi,20*log10(abs(Hhm91)),':','Linewidth',2)
legend('M=31','M=61','M=91')
%axis([xlim -200 20])
grid
xlabel('normalized frequency (\times\pi rad./sample)')
ylabel('magnitude')
title('H(\omega), Hamming window')

figure(14),subplot(111),plot(w/pi,20*log10(abs(Hhn31)),'-',...
   w/pi,20*log10(abs(Hhn61)),'--',w/pi,20*log10(abs(Hhn91)),':','Linewidth',2)
legend('M=31','M=61','M=91')
%axis([xlim -200 20])
grid
xlabel('normalized frequency (\times\pi rad./sample)')
ylabel('magnitude')
title('H(\omega), Hanning window')


