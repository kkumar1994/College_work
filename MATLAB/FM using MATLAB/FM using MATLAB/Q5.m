clear all
clc
%% Part 1
%Instantiating the signal parameters:
t0 = 0.1;
ts = 0.0001;
simulationTime = 0.2;
fs = 1/ts;
t = [0:ts:simulationTime-ts];
%Creating the original message signal:
m(1) = 0;
for i = 2:length(t)
m = [m m(i-1)+ts];
end
%Computing the integral of the message signal:
m_integral(1)=0;
for i = 1:length(t)-1
m_integral(i+1) = m_integral(i) + (m(i)*ts);
end
clear i;
fc = 250;
kf = 100;
%Plotting both m(t) and the integral of m(t):
plot(t,m)
title('Original Message Signal')
xlabel('Time(s)')
ylabel('m(t)')
figure();
plot(t,m_integral)
title('Integral of Message Signal')
xlabel('Time(s)')
%% Part 2
%In order to compute the bandwidth of the modulated signal, the spectrum
%of u(t) must first be determined:
u = cos(2*pi*fc*t + (2*pi*kf*m_integral));
length_u_fft = 2^(nextpow2(length(u)));
U = fft(u,length_u_fft);
U = U/fs;
U = fftshift(U);
f = [-length(U)/2:length(U)/2 - 1];
figure();
plot(f,abs(U))
title('Spectrum of the Modulated Signal')
xlabel('Frequency')
%Using the spectrum of u(t), the bandwidth may now be determined by
%calculating the range of frequencies that contain the majority of the
%modulated signal. This is done by simply analyzing the plot. The
%bandwidth is calculated in this way because Carson's rule cannot be
%applied in the context of this problem.
%% Part 3
%The modulated signal is recalculated for completeness. It is also
%resampled, with only 1,999 samples being taken. A reduced number of
%samples were performed in order to make the computation in the next part
%more straightforward.
t = [-t0:ts:t0-(2*ts)];
m_integral = m_integral(1:1999);
u = cos(2*pi*fc*t + (2*pi*kf*m_integral));
figure();
plot(t,u)
title('Modulated Message Signal')
xlabel('Time(s)')
ylabel('u(t)')
%% Part 4
%First computing the spectrum of the original message signal, m(t):
length_m_fft = 2^(nextpow2(length(m)));
M = fft(m,length_m_fft);
M = M/fs;
M = fftshift(M);
df = fs/length_m_fft;
f = [0:df:df*(length(M)-1)]-fs/2;
figure()
plot(f,abs(M))
title('Spectrum of the Message Signal')
xlabel('Frequency')
%Now computing the spectrum of the modulated signal, u(t):
length_u_fft = 2^(nextpow2(length(u)));
U = fft(u,length_u_fft);
U = U/fs;
U = fftshift(U);
df = fs/length_u_fft;
f = [0:df:df*(length(U)-1)]-fs/2;
figure();
plot(f,abs(U))
title('Spectrum of the Modulated Signal')
xlabel('Frequency')
%% Part 5
%Initializing the variables required for modeling the received signal
%sequences with noise applied:
sigma01 = 0.1;
sigma1 = 1;
sigma2 = 2;
wc = randn(1,1999);
ws = randn(1,1999);
n = [-999:1:999];
%Applying noise to each received signal sequence for each value of sigma:
r_sigma01 = u + sigma01*(wc.*cos(2*pi*fc*t) - ws.*sin(2*pi*fc*t));
r_sigma1 = u + sigma1*(wc.*cos(2*pi*fc*t) - ws.*sin(2*pi*fc*t));
r_sigma2 = u + sigma2*(wc.*cos(2*pi*fc*t) - ws.*sin(2*pi*fc*t));
%Plotting the received signal for each value of sigma:
figure();
plot(t,r_sigma01)
title('Received Signal for Sigma = 0.1')
xlabel('Time(s)')
figure();
plot(t,r_sigma1)
title('Received Signal for Sigma = 1')
xlabel('Time(s)')
figure();
plot(t,r_sigma2)
title('Received Signal for Sigma = 2')
xlabel('Time(s)')


%% Part 6
%First, the Hilbert function of the received signal is taken for each value
%of sigma. Then, the result is multiplied by an exponential in order to
%remove the influence of the carrier frequency.
r_sigma01 = hilbert(r_sigma01).*exp(-j*2*pi*fc*t);
r_sigma1 = hilbert(r_sigma1).*exp(-j*2*pi*fc*t);
r_sigma2 = hilbert(r_sigma2).*exp(-j*2*pi*fc*t);
%Recall that the original m(t) is contained within the PHASE of the
%received signal. Therefore, the phase is calculated for each received
%signal sequence:
r_sigma01_angles = unwrap(angle(r_sigma01));
r_sigma1_angles = unwrap(angle(r_sigma1));
r_sigma2_angles = unwrap(angle(r_sigma2));
%The original message signal may be obtained by differentiating the
%phase and then removing the 2*pi*kf term:
r_sigma01 = (diff(r_sigma01_angles)/ts)/(2*pi*kf);
r_sigma1 = (diff(r_sigma1_angles)/ts)/(2*pi*kf);
r_sigma2 = (diff(r_sigma2_angles)/ts)/(2*pi*kf);
%Plotting the results:
t = t(1:1998);
figure();
plot(t,r_sigma01);
title('Demodulated Signal w/ Sigma = 0.1');
xlabel('Time(s)')
figure();
plot(t,r_sigma1);
title('Demodulated Signal w/ Sigma = 1');
xlabel('Time(s)')
figure();
plot(t,r_sigma2);
title('Demodulated Signal w/ Sigma = 2');
xlabel('Time(s)')