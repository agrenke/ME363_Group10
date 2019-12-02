function [panels] = definePanels(x,y,N,alpha)
%DEFINEPANELS Discretizes geometry into panels 
%   using the cosine method



% STILL NEED TO IMPLEMENT THE COSINE METHOD!

%     R = (max(x) - min(x))/2; % Calculates the circle radius
%     xCenter = (max(x) - min(x)) / 2;
%     theta = linspace(0,2*pi,N+1); % Equal spaced thetas
%     xCircle = xCenter + R*cos(theta);
%     xEnds = xCircle;

rot = [cosd(alpha), -sind(alpha); sind(alpha), cosd(alpha)];
for i = 1:N
    panels(i) = Panel(x(i),y(i),x(i+1),y(i+1),rot);
end


end

