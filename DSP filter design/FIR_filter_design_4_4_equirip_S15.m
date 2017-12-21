% Executes the Equiripple design code equirip_design.m for different filter lengths.

% Close figure windows
close all

f_p = 0.4;    % normalized passband frequency
f_s = 0.5;    % normalized stopband frequency
M = 15;

for delta=[1 2],
    
    % Execute design and determine frequency response
    [h,H,w,f,rip_p,rip_s]=equiripple_lowpass(f_p,f_s,M,delta);

    % Truncate ripple values for plotting purposes
    rip_pr = floor(1000*rip_p)/1000;
    rip_sr = floor(1000*rip_s)/1000;

    % Plot the impulse response
    figure,stem([0:M-1],h),grid,xlabel('n'),ylabel('h(n)','Linewidth',2)
    title(['Equiripple Design: M = ',num2str(M),', \delta_2/\delta_1 = ',num2str(delta)])

    % Plot the frequency response
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
    title(['Equiripple Design: M = ',num2str(M),', \delta_2/\delta_1 = ',num2str(delta)])

    % Plot the frequency response on a db scale
    figure
    plot(f,20*log10(abs(H)),'Linewidth',2)
    set(gca,'XTick',[0 f_p f_s 1])
    grid
    xlabel('normalized frequency \omega/\pi')
    ylabel('|H(\omega)| (in db)')
    title(['Equiripple Design: M = ',num2str(M),', \delta_2/\delta_1 = ',num2str(delta)])
    
end

delta = 1;    % stopband-to-passband weight ratio

for M = [31 61 91],      % filter length 
    
    % Execute design and determine frequency response
    [h,H,w,f,rip_p,rip_s]=equiripple_lowpass(f_p,f_s,M,delta);

    % Truncate ripple values for plotting purposes
    rip_pr = floor(1000*rip_p)/1000;
    rip_sr = floor(1000*rip_s)/1000;

    % Plot the impulse response
    figure,stem([0:M-1],h),grid,xlabel('n'),ylabel('h(n)','Linewidth',2)
    title(['Equiripple Design: M = ',num2str(M),', \delta_2/\delta_1 = ',num2str(delta)])

    % Plot the frequency response
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
    title(['Equiripple Design: M = ',num2str(M),', \delta_2/\delta_1 = ',num2str(delta)])
    
    % Plot the frequency response on a db scale
    figure
    plot(f,20*log10(abs(H)),'Linewidth',2)
    set(gca,'XTick',[0 f_p f_s 1])
    grid
    xlabel('normalized frequency \omega/\pi')
    ylabel('|H(\omega)| (in db)')
    title(['Equiripple Design: M = ',num2str(M),', \delta_2/\delta_1 = ',num2str(delta)])
    
end


%num_fig = gcf;
%for k=1:num_fig
%    exportfig(k,['fig_',num2str(k),'.eps'],'width',5)
%end