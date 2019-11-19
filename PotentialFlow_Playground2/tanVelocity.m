function [vt] = tanVelocity(panels,freestream,gamma,A_source,B_vortex)
%TANVELOCITY computes the tangential velocity of the panels

A = zeros([size(panels,2),size(panels,2)+1]);

A(:,1:end-1) = B_vortex;

A(:,end) = -sum(A_source,2);

b = freestream.uInf * sin(freestream.alpha - [panels.beta]);

strengths = [[panels.sigma],gamma];

vt = mtimes(A,strengths') + b';

end