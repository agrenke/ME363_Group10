% Potential Flow Try 2 --> Inspired from L.A. Barba AeroPython
%       Thanks to Winston for pointing us to that great resource!
% https://nbviewer.jupyter.org/github/barbagroup/AeroPython/blob/master/lessons/11_Lesson11_vortexSourcePanelMethod.ipynb


clear all;
close all;

fileName = 'n0012.csv';
raw = csvread(fileName);
x = raw(:,1);
y = raw(:,2);
N = size(raw,1)-1;

% General Simulation Constants
uInf = 1;
alpha = 15;

panels = definePanels(x,y,N,alpha); % discretizing airfoil into panels

freestream = Freestream(uInf,alpha);

A_source = sourceContNormal(panels);
B_vortex = vortexContNormal(panels);

A = buildSingularityMatrix(A_source,B_vortex);
b = buildFreeStream(panels,freestream);

strengths = linsolve(A,b);
%strengths = mldivide(A,b);
%strengths = A/b;


for i = 1:size(panels,2)
   panels(i).sigma = strengths(i);
end

gamma = strengths(end);

vt = tanVelocity(panels,freestream,gamma,A_source,B_vortex);

for i = 1:length(panels)
    panels(i).vt = vt(i);
    panels(i).cp = 1.0 - (panels(i).vt / freestream.uInf)^2;
end

% accuracy given as a percentage!
accuracy = sum([panels.sigma].*[panels.length])./sum(abs([panels.sigma].*[panels.length])); % Should be zero!

chord = abs(max([panels.xa])-min([panels.xa]));
cl = (gamma*sum([panels.length]))/(0.5*freestream.uInf*chord);


%% Freestream calcs
xStart = -150;
xEnd = 150;
yStart = -150;
yEnd = 150;
% rot = [cosd(alpha), -sind(alpha); sind(alpha), cosd(alpha)];
% tmpRot = ([panels.xc; panels.yc]'*rot);
% [panels.xRot] = tmpRot(:,1);
% panels.yRot = tmpRot(:,2);

gridResXY = 500;

[X,Y] = meshgrid(linspace(xStart,xEnd,gridResXY),linspace(yStart,yEnd,gridResXY));

[u,v] = velocityField(panels,freestream,X,Y);

% [ut,vt] = velocityField(panels,freestream,[panels.xc],[panels.yc]);

cp = 1.0 - (u.^2 + v.^2) / freestream.uInf.^2;

%% Plots!

% Plotting airfoil
figure;
    scatter([panels(string({panels.loc}')=={'upper'}).xc],...
        [panels(string({panels.loc}')=={'upper'}).yc],'r')
hold on;
    scatter([panels(string({panels.loc}')=={'lower'}).xc],...
        [panels(string({panels.loc}')=={'lower'}).yc],'b')
    axis equal;
    %quiver(X,Y,u,v) ,['LineWidth',2]
    streamline(X,Y,u,v,linspace(xStart,xStart,gridResXY*10),linspace(yStart,yEnd,gridResXY*10))
    saveas(gcf,'vector.png')


% Plotting airfoil
figure;
    scatter([panels.xc],...
        [panels.yc],[],[panels.sigma])
    hold on;
    quiver(X,Y,u,v) %,['LineWidth',2]
    %streamline(X,Y,u,v,[panels.xc],[panels.yv])
    colorbar
    saveas(gcf,'strength.png')
    
    
% Plotting Cp
figure;
scatter([panels(string({panels.loc}')=={'upper'}).xc],...
        [panels(string({panels.loc}')=={'upper'}).cp],'r')
    hold on;
    scatter([panels(string({panels.loc}')=={'lower'}).xc],...
        [panels(string({panels.loc}')=={'lower'}).cp],'b')
hold off;
title('Naca0012 Cp')
legend({'upper surface','lower surface'})
xlabel('x')
ylabel('Cp')

saveas(gcf,'cp.png')

% Plotting Vt
figure;
scatter([panels(string({panels.loc}')=={'upper'}).xc],...
        [panels(string({panels.loc}')=={'upper'}).vt],'r')
    hold on;
    scatter([panels(string({panels.loc}')=={'lower'}).xc],...
        [panels(string({panels.loc}')=={'lower'}).vt],'b')
hold off;
title('Naca0012 Tangential Velocity')
legend({'upper surface','lower surface'})
xlabel('x')
ylabel('Vt')

saveas(gcf,'tangentialVelocity.png')

figure; 
%contourf(X,Y,power(power(u,2)+power(v,2),0.5),100,'edgecolor','none')
contourf(X,Y,cp,100,'edgecolor','none')
hold on;
%patch([panels.xc],[panels.yc],'black')
scatter([panels.xc],[panels.yc],[],'black')
h = streamline(X,Y,u,v,[panels.xc],[panels.yc]);
set(h,'LineWidth',0.5,'Color','black')
title('Cp + Streamlines - NACA0012')
colorbar
xlabel('x')
ylabel('y')
axis([-10 110 -100 100])
axis equal
saveas(gcf,'cP_streamlines.png')
%quiver(X,Y,u,v)

% 
% 
% figure;
%     scatter([panels(string({panels.loc}')=={'upper'}).xc],...
%         [panels(string({panels.loc}')=={'upper'}).yc],'r')
% hold on;
%     scatter([panels(string({panels.loc}')=={'lower'}).xc],...
%         [panels(string({panels.loc}')=={'lower'}).yc],'b')
%     axis equal;
%     %quiver(X,Y,u,v) ,['LineWidth',2]
%     streamline(X,Y,u,v,linspace(xStart,xStart,gridResXY*10),linspace(yStart,yEnd,gridResXY*10))
%     saveas(gcf,'vector.png')