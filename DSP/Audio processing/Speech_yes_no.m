%We divide the sum mag FFT of low freq by 
%sum mag FFT of the high freq
%Applicable to any random signal since the feature is a ratio
%and the ratio is independent of the length of the input

fs=input('sampling frequency');
[x,Fs]=audioread('no.wav');
threshold = 12; %threshold value
N = length(x);
k1 = round(N*5000/fs); % FFT for 5000 Hz
k2 = round(N*11025/fs); % FFT for 11025 Hz
X = abs(fft(x));
f = sum(X(1:k1))/sum(X(k1:k2)); % feature extraction
if f < threshold,
 output = 'yes'; % if feature is below threshold, return 'yes'
else
 output = 'no'; % if feature is above threshold, return 'no'
end
