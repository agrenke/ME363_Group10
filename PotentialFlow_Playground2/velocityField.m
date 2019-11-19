function [u,v] = velocityField(panels,freestream,X,Y)
%VELOCITYFILED uses provided X and Y meshgrids to determine the velocity 
%    field around the body

u = freestream.uInf * cos(freestream.alpha) * ones(size(X,1));
v = freestream.uInf * sin(freestream.alpha) * ones(size(X,1));

for i = 1:length(panels)
    disp(i)
    u = u + ((panels(i).sigma/(2*pi))*Integral(X,Y,panels(i),1,0));
    v = v + ((panels(i).sigma/(2*pi))*Integral(X,Y,panels(i),0,1));
%     for j = 1:length(X)
%         for f = 1:length(Y)
%             u(j,f) = u(j,f) + ((panels(i).sigma/2*pi)*Integral(X(j,f),Y(j,f),panels(i),1,0));
%             v(j,f) = v(j,f) + ((panels(i).sigma/2*pi)*Integral(X(j,f),Y(j,f),panels(i),1,0));
%         end
%     end
end