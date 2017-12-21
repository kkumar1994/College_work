% Least Squares Linear Phase FIR Filter Design
% Lowpass design with symmetric filter and M odd (# of coeffs)

% Set up basic design parameters
f_p = 0.4;    % normalized passband frequency
f_s = 0.5;    % normalized stopband frequency
M = 15;       % filter length (should be odd)
for alpha = [0.1 0.5 .95];  % weighting parameter


% Set up band edges in angular frequencies and
% determine the number of free parameters (L) after
% imposing the linear phase constraint
w_p = f_p*pi;
w_s = f_s*pi;
L = (M-1)/2;

% Determine the matrix functions C and d for passband and stopband
Cp = zeros(L+1,L+1);
Cs = zeros(L+1,L+1);
for m=0:L
   for n=0:L
      if and(m==0,n==0),
         Cp(m+1,n+1) = w_p;
         Cs(m+1,n+1) = pi-w_s;
            else if m==n,
                  Cp(m+1,n+1) = 0.5*(w_p+(sin(2*n*w_p))/(2*n));
                  Cs(m+1,n+1) = 0.5*((pi-w_s) - (sin(2*n*w_s))/(2*n));
               else
                  Cp(m+1,n+1) = 0.5*((sin((m+n)*w_p))/(m+n) + (sin((m-n)*w_p))/(m-n));
                  Cs(m+1,n+1) = -0.5*((sin((m+n)*w_s))/(m+n) + (sin((m-n)*w_s))/(m-n));
               end
      end
   end
end

d = zeros(L+1,1);
for m=0:L
   if m==0,
      d(m+1) = w_p;
   else
      d(m+1) = (sin(m*w_p))/m;
   end
end

% Calculate the filter coefficients
C = alpha*Cp + (1-alpha)*Cs;
d = alpha*d;
a = C\d;
h = [flipud(a(2:L+1))/2 ; a(1) ; a(2:L+1)/2];

% Plot the impulse response
figure,stem([0:M-1],h),grid,xlabel('n'),ylabel('h(n)')
title(['Least Squares design: M = ',num2str(M),', \alpha = ',num2str(alpha)])

% Calculate and plot the frequency response
N = 4096;
f = [0:N]/N;
w = [0:N]*pi/N;
unit_val = ones(size(w));

H = freqz(h,1,w);

   % Determine passband ripple and stopband ripple
   rip_p = max(abs(abs(H(1:floor(f_p*N)))-1));
   rip_s = max(abs(H(ceil(f_s*N):N+1)));
   rip_pr = floor(1000*rip_p)/1000;
   rip_sr = floor(1000*rip_s)/1000;
   
figure
plot(f,abs(H),'Linewidth',2)
axis([0 1 0 1.2])
set(gca,'XTick',[0 f_p f_s 1])
set(gca,'YTick',[0 rip_s 1-rip_p 1 1+rip_p])
set(gca,'YTickLabel','0| | |1| ')
grid
   text( 0.025, 1-rip_p-0.05, ['Passband ripple = ',num2str(rip_pr)]);
   text( 0.025, rip_s+0.05, ['Stopband ripple = ',num2str(rip_sr)]);
xlabel('normalized frequency \omega/\pi')
ylabel('|H(\omega)|')
title(['Least Squares design: M = ',num2str(M),', \alpha = ',num2str(alpha)])
end
