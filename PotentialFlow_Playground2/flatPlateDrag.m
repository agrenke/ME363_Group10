function [delta, tau, drag] = flatPlateDrag(panels,freestream)
%FLATPLATDRAG computes the drag  on each panel with the flat plate assumptions
% USE WITH CAUTION!! (is probably a poor assumption)

    mu = 1.81E-5;
    rho = 1.225;

    vu = mu./rho;

    delta = zeros([length(panels),1]);
    tau = zeros([length(panels),1]);
    drag = zeros([length(panels),1]);
    minPanX = min([panels.xc]);
    
    for i = 1:length([panels])
        panels(i).blV = panels(i).vt;
        disp(['Panels BL Solving = ',num2str(i)]);

        for j = 1:3
            delta(i) = 5.48*sqrt(vu*(panels(i).xc-minPanX))/abs(panels(i).blV);
            if(string({panels(i).loc}')=={'lower'})
                panels(i).blY = panels(i).yc-(delta(i)+0.00001);
                panels(i).blV = velocityField(panels,freestream,panels(i).xc,panels(i).blY);
                
            else
                panels(i).blY = panels(i).yc+(delta(i)+0.00001);
                panels(i).blV = velocityField(panels,freestream,panels(i).xc,panels(i).blY);
            end
        end
        

        %delta(i) = 5.48*sqrt(vu*(panels(i).xc-minPanX))/abs(panels(i).blV);
        tau(i) = 2*mu*(abs(panels(i).blV))/(delta(i)+0.00001);
        drag(i) = tau(i) * panels(i).length;
    end

    %uTmp = velocityField(panels,freestream,panels(i).xc,panels(i).yc+delta(i))
    
end

