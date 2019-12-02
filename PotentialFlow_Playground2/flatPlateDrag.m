function [delta, tau, drag] = flatPlateDrag(panels)
%FLATPLATDRAG computes the drag  on each panel with the flat plate assumptions
% USE WITH CAUTION!! (is probably a poor assumption)

    mu = 1.81E-5;
    rho = 1.225;

    vu = mu./rho;

    delta = zeros([length(panels),1]);
    tau = zeros([length(panels),1]);
    drag = zeros([length(panels),1]);
    minPanX = min([panels.xc])
    for i = 1:length([panels])
        delta(i) = 5.48*sqrt(vu*(panels(i).xc-minPanX))/abs(panels(i).vt);
        tau(i) = 2*mu*(abs(panels(i).vt))/(delta(i)+0.00001);
        drag(i) = tau(i) * panels(i).length;
    end
    
end

