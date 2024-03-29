% Potential Flow Try 2 --> Inspired from L.A. Barba AeroPython
%       Thanks to Winston for pointing us to that great resource!
% https://nbviewer.jupyter.org/github/barbagroup/AeroPython/blob/master/lessons/11_Lesson11_vortexSourcePanelMethod.ipynb


clear all;
close all;

%%% GEOMETRY IMPORT %%% 
% Feed "raw" array x, y columns of shape

%fileName = 'n0012.csv';
%fileName = 'abde_ellipse001.csv';
%fileName = 'Geometry_Ellipse.csv';
%fileName = 'Geometry_Ellipse_200.csv';
% fileName = 'Naca_29.csv';
%fileName = 'Naca_59.csv';
%fileName = 'Naca_79.csv';
%fileName = 'Naca_109.csv';
fileName = 'Naca_139.csv';
%fileName = 'Naca_199.csv';
%fileName = 'Egg3t1.csv';
%fileName = 'SuperEllipse2t1.csv'

raw = csvread(['geometry/',fileName]);
leng = max(raw(:,1))-min(raw(:,1));
scal = 0.05/leng;
x = raw(:,1)*scal;
y = raw(:,2)*scal ;
N = size(raw,1)-1;

% General Simulation Constants
uInf = 1;
alpha = 5;
rho = 1.225;

fileName = ['figures/',fileName];
fileSaveDesc = [fileName(1:end-4),'_uInf-',num2str(uInf),'_AoA-',num2str(alpha)];

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


%% Boundary Layer Approximations 

% WARNING! !!! Assumption for flat plate assumes dU/dX is small !!!
[delta, tau, drag] = flatPlateDrag(panels,freestream); % computes the drag for each panel
for i = 1:length([panels])
    panels(i).delta = delta(i);
    panels(i).tau = tau(i);
    panels(i).drag = drag(i);

    if(string({panels(i).loc}')=={'lower'})
        panels(i).blY = panels(i).yc-(delta(i)+0.00001);
    else
        panels(i).blY = panels(i).yc+(delta(i)+0.00001);
    end
end

dragTot = sum(drag); % sum all of the panels' drag
cdTot = (2*dragTot)/(rho*power(uInf,2)*(max(x)-min(x)));


% WARNING! !!! Calculates dP/dX for airfoil !!!
dCpAirfoil = gradient(abs([panels.cp]));


%% Freestream calcs
fieldScale = 0.025;
% xConst = 2.5;
% yConst = 5;
% xStart = min(x)*xConst-0.01;
% xEnd = max(x)*xConst;
% yStart = min(y)*yConst;
% yEnd = max(y)*yConst;

xStart = -0.05;
xEnd = 0.1;
yStart = -0.03;
yEnd = 0.03;

% rot = [cosd(alpha), -sind(alpha); sind(alpha), cosd(alpha)];
% tmpRot = ([panels.xc; panels.yc]'*rot);
% [panels.xRot] = tmpRot(:,1);
% panels.yRot = tmpRot(:,2);

gridResXY = 300;

[X,Y] = meshgrid(linspace(xStart,xEnd,gridResXY),linspace(yStart,yEnd,gridResXY));

[u,v] = velocityField(panels,freestream,X,Y);
V_tot = sqrt(power(u,2)+power(v,2));
% [ut,vt] = velocityField(panels,freestream,[panels.xc],[panels.yc]);

cp = 1.0 - (u.^2 + v.^2) / freestream.uInf.^2;


%% Plots!
dS = 15;
lw = 1.5;
titleDesc = [' AoA=',num2str(alpha),'� Uinf=',num2str(uInf),' m/s Cl=',num2str(cl,4),' Cd=',num2str(cdTot,2)];
%%% vvvvvv  UNCOMMENT FOR PLOTS! vvvvvvvv 

% Plot 
figure; plot([panels.xc],[panels.yc]); hold on; plot([panels.xc],[panels.blY])


% Plotting airfoil
figure;
    h1 = plot([panels(string({panels.loc}')=={'upper'}).xc],...
        [panels(string({panels.loc}')=={'upper'}).yc],'-o','color','r','LineWidth',lw);
    set(h1, 'markerfacecolor', get(h1, 'color'))
hold on;
    h2 = plot([panels(string({panels.loc}')=={'lower'}).xc],...
        [panels(string({panels.loc}')=={'lower'}).yc],'-o','color','b','LineWidth',lw);
    set(h2, 'markerfacecolor', get(h2, 'color'));
    axis equal;
    axis([xStart xEnd yStart yEnd])
    %quiver(X,Y,u,v) ,['LineWidth',2]
    streamline(X,Y,u,v,linspace(xStart,xStart,gridResXY/dS),linspace(yStart,yEnd,gridResXY/dS))
    set(gcf,'renderer','Painters')
    saveas(gcf,[fileSaveDesc,'_vector.eps'],'epsc')


% Plotting airfoil With Source Strenghts
% figure;
%     scatter([panels.xc],...
%         [panels.yc],[],[panels.sigma])
%     hold on;
%     quiver(X,Y,u,v) %,['LineWidth',2]
%     %streamline(X,Y,u,v,[panels.xc],[panels.yv])
%     colorbar
%     saveas(gcf,[fileSaveDesc,'_strength.png'])
    
    
% Plotting Cp
figure;
    h1 = plot([panels(string({panels.loc}')=={'upper'}).xc],...
            [panels(string({panels.loc}')=={'upper'}).cp],'-o','color','r','LineWidth',lw);
        hold on;
    set(h1, 'markerfacecolor', get(h1, 'color'))
    h2 = plot([panels(string({panels.loc}')=={'lower'}).xc],...
            [panels(string({panels.loc}')=={'lower'}).cp],'-o','color','b','LineWidth',lw);
    set(h2, 'markerfacecolor', get(h2, 'color'))
    hold off;
    title(['Cp',titleDesc])
    legend({'upper surface','lower surface'})
    xlabel('x')
    ylabel('Cp')
    set(gcf,'renderer','Painters')
    saveas(gcf,[fileSaveDesc,'_cp.eps'],'epsc')

% Plotting Vt
%     figure;
%     scatter([panels(string({panels.loc}')=={'upper'}).xc],...
%             [panels(string({panels.loc}')=={'upper'}).vt],'r')
%         hold on;
%         scatter([panels(string({panels.loc}')=={'lower'}).xc],...
%             [panels(string({panels.loc}')=={'lower'}).vt],'b')
%     hold off;
%     title('Tangential Velocity')
%     legend({'upper surface','lower surface'})
%     xlabel('x')
%     ylabel('Vt')
%     saveas(gcf,[fileSaveDesc,'_tangentialVelocity.png'])

figure; 
    %contourf(X,Y,power(power(u,2)+power(v,2),0.5),100,'edgecolor','none')
    contourf(X,Y,cp,100,'edgecolor','none')
    colormap(jet)
    hold on;
    %patch([panels.xc],[panels.yc],'black')
    %scatter([panels.xc],[panels.yc],[],'black')
    patch([panels.xc],[panels.yc],'black')
    h= streamline(X,Y,u,v,linspace(xStart,xStart,gridResXY/dS),linspace(yStart,yEnd,gridResXY/dS));
    % h = streamline(X,Y,u,v,[panels.xc],[panels.yc]); % Steamlines planted
                % inside of the airfoil
    set(h,'LineWidth',0.5,'Color','black')
    title(['Cp + Streamlines',titleDesc])
    colorbar
    xlabel('x')
    ylabel('y')
    axis([xStart xEnd yStart yEnd])
    axis equal
    set(gcf,'renderer','Painters')
    saveas(gcf,[fileSaveDesc,'_cP_streamlines.eps'],'epsc')

figure; 
    contourf(X,Y,V_tot,100,'edgecolor','none')
    colormap(jet)
    hold on;
    %scatter([panels.xc],[panels.yc],[],'black')
    plot([panels.xc],[panels.blY],'-','color','black','LineWidth',lw)
    quiver(X(1:dS:end,1:dS:end),Y(1:dS:end,1:dS:end),u(1:dS:end,1:dS:end),v(1:dS:end,1:dS:end),'color','k')
    patch([panels.xc],[panels.yc],'black');
    %h = streamline(X,Y,u,v,[panels.xc],[panels.yc]);
    %set(h,'LineWidth',0.5,'Color','black')
    title(['Velocity',titleDesc])
    colorbar
    xlabel('x')
    ylabel('y')
    %axis([xStart xEnd yStart yEnd])
    axis equal
    set(gcf,'renderer','Painters')
    saveas(gcf,[fileSaveDesc,'_Vtot_streamlines.eps'],'epsc')


%%% ^^^^^   UNCOMMENT FOR PLOTS! ^^^^^^



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
