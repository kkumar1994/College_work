


function [gsrv1,gsrv2]=gngauss(m,sgma)
%Choose an arbitrary value of N
N=10000;
u=rand(N,1); % a uniform random variable in (0,1)
%z=sgma*(sqrt(2*log(1/(1.-u)))); % a Rayleigh distributed random variable
u_ = -1*u;
u_2 = 1+u_;

z = sgma*(sqrt(2*log(1./u_2)));
v=rand(N,1); % another uniform random variable in (0,1)
gsrv1=m+z.*cos(2*pi*v);
gsrv2=m+z.*sin(2*pi*v);


hist(gsrv1,20)
plot (gsrv1)

end
