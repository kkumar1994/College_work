function ECE569Project(B,A,delay,Experiment_type)

hfi=figure;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 1. Set some general known signal parameters %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
params.N = 5000;          % number of symbols. There are 5000 symbols modulated
                          % in the signal in the files to be loaded.
params.bitsPerSym   = 2;  % The constalation is such that there are 2 bits per symbol
params.pulsePerSym  = 1;  % Each symbol comprises of one pulse
params.sampPerPulse = 15; % The sampling rate is such that there are 15 samples per symbol 
params.bitFileName  = 'TransmittedBits.mat';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2. Load the file containing the signal to be processed %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% There are 4 types of signal stored in 4 files. The first type, and the one you
% should load to get a feel for things is the one named totalSignalFile_Clean.
% The signal in this file is uncorrupted by noise or the interfering signal, and
% you should get BER = 0 as a result. Uncomment one other line at a time to load
% the corrupted signals, either by noise, or the interferer, or both, to
% excercise you filter design.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch Experiment_type
    case 'clean'
        load totalSignalFile_Clean         % the desired signal is not at baseband
    case 'interferer'
        load totalSignalFile_InterfereOnly  % note the interferer next to the desired signal
    case 'noise'
        load totalSignalFile_NoiseOnly      % note the amount of noise present
    case 'both'
        load totalSignalFile_NoiseAndInterfere % both interferer and noise are present
end

figure(hfi)
subplot(231)
plot(totalSignal)
axis([1 params.N*params.sampPerPulse -1.25*max(totalSignal) 1.25*max(totalSignal)])
title('Time domain of the recived signal')

totalSignalSpec = fft(totalSignal)/length(totalSignal);
fvec = (0:length(totalSignal)-1)/length(totalSignal)*2*pi;

%figure
subplot(232)

plot(fvec,abs(totalSignalSpec)./max(abs(totalSignalSpec)),'b')
title('The spectrum of the recived signal')
ylabel('spectrum magnitude |S(w)|')
xlabel('w [rad/sample]')
set(gca,'YScale','log')

Nfft=2048;
[H,W] = freqz(B,A,Nfft,'whole');
hold on
plot(W,abs(H),'r')
legend({'Signal','Filter'})
axis([0, 2*pi, 10e-5, 1])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3. Set some receiver specific parameters %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
shapedPulse = hann(params.sampPerPulse);
rxParams.pulseEn = shapedPulse'*shapedPulse;
rxParams.BWcoef = 0.06;
rxParams.desiredFreq = 3.2/17;
rxParams.shapedPulse = shapedPulse;
rxParams.delay = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 4. Send the signal to the receiver for demodulation %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Performance before the signal clean-up')
recBits=projectECE569Receiver(totalSignal,params,rxParams);
subplot(233)
imagesc(reshape(recBits,100,100))
title('Received image')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 5. Clean up the signal from the interferer and noise %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This is where you need to enter your code to clean up the signal using a
% band-pass filter. You need to insert here the filter design routine which will
% generate the filter with the given specifications, and filter the signal vector
% named totalSignal. Your resulting, filtered, vector also needs to have the
% name totalSignal. Do not change other code unless you know what you are doing.
% Section 6 below plots the new filtered signal, both in time and frequency
% domain. Unless you are very familiar with Matlab code, only insert your
% filtering code in this section.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

totalSignal = filter(B,A,totalSignal);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 6. Plot the new filtered totalSignal %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(234)
plot(totalSignal)
axis([1 params.N*params.sampPerPulse -1.25*max(totalSignal) 1.25*max(totalSignal)])
title('Time domain of the filtered signal')

totalSignalSpec = fft(totalSignal)/length(totalSignal);
fvec = (0:length(totalSignal)-1)/length(totalSignal)*2*pi;

subplot(235)

plot(fvec,abs(totalSignalSpec)/max(abs(totalSignalSpec)),'b')
title('The spectrum of the filtered  signal')
xlabel('w [rad/sample]')
ylabel('spectrum magnitude |S(w)|')
set(gca,'YScale','log')
axis([0, 2*pi, 10e-5, 1])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 7. Send the signal to the receiver for demodulation %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% The receiver will try to demodulate bits again, and if your filtering worked
% correctly, the new bit error rate will be better than the one obtained in
% Section 4 above.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rxParams.delay = delay;

disp('Performance after the signal clean-up')
recBits=projectECE569Receiver(totalSignal,params,rxParams);

subplot(236)
imagesc(reshape(recBits,100,100))
title('Received image')
