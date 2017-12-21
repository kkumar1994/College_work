
%%%%%%%%%%%%%%%%%%%
%%%  DRAW MASK  %%%
%%%%%%%%%%%%%%%%%%%
Lw=2*pi; % for x -axis from 0-2pi
%Lw=1; % for x -axis from 0-1

wp1 = 0.25*1/2*Lw;
wp2 = 0.50*1/2*Lw;
delp = 0.1;

ws1 = 0.2*1/2*Lw;
ws2 = 0.55*1/2*Lw;
dels = 0.05;

%figure
Htop=1.4;

rectangle('Position', [0 ,dels ws1,Htop-dels],'FaceColor',[0.9 0.9 0.9] );
rectangle('Position', [wp1 ,0.001 wp2-wp1,1-delp],'FaceColor',[0.9 0.9 0.9] );
rectangle('Position', [wp1 ,1+delp wp2-wp1,Htop-(1+delp)],'FaceColor',[0.9 0.9 0.9] );

rectangle('Position', [ws2,dels, 1*Lw-2*ws2,Htop-dels],'FaceColor',[0.9 0.9 0.9] );

rectangle('Position', [1*Lw-wp2 ,1+delp wp2-wp1,Htop-(1+delp)],'FaceColor',[0.9 0.9 0.9] );
rectangle('Position', [1*Lw-wp2 ,0.001 wp2-wp1,1-delp],'FaceColor',[0.9 0.9 0.9] );

rectangle('Position', [1*Lw-ws1 ,dels ws1,Htop-dels],'FaceColor',[0.9 0.9 0.9] );

axis([0 1*Lw 0.0001 Htop])
xlabel('\omega [rad/sample]')
%%%%%% Use for log scale plot
%    set(gca,'YScale','log')
%    axis([0 1*Lw 0.0001 Htop])


hold on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% plot here !

%xlabel(' somthing ') 
%ylabel(' somthing ') 
%title(' somthing ')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

