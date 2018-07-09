function output = dtmf(x,fs)
Button = [
 1,2,3;4,5,6;7,8,9;10,11,12]; %Button values
N = 512; % Fourier Transform values
rows = round([697 770 852 941]*N/fs); % DTMF row frequencies
cols = round([1209 1336 1477]*N/fs); % DTMF col frequencies
str = round(length(x)/2-N/2); % start DFT in center of recording
X = fft(x(str:str+N-1)); % Compute the DFT of length N
[q,r] = max(abs(X(rows))); % Find row with highest mag
[q,c] = max(abs(X(cols))); % Find col with highest mag
output = Button(r,c); 