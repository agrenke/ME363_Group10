function [panels] = Panel(xa,ya,xb,yb,rot)
%PANELS defines panel information

    panels.xa = xa;
    panels.xb = xb;
    panels.ya = ya;
    panels.yb = yb;
    
    panels.xc = (xa + xb) / 2;
    panels.yc = (ya + yb) / 2;
    
    panels.length = sqrt(((xb-xa)^2)+((yb-ya)^2));
    
    % Calculation of Beta angles (angle b/w panels)
    if (xb - xa) <= 0
        panels.beta = acos((yb-ya)/panels.length);
    elseif (xb - xa) > 0
        panels.beta = pi + acos(-(yb-ya)/panels.length);
    end
    
    % Location of Panels (up / down)
    if (panels.beta <= pi)
        panels.loc = 'upper';
    else
        panels.loc = 'lower';
    end
    
    panels.sigma = 0;       % source strength
    panels.vt = 0;          % tangential velocity
    panels.cp = 0;          % coefficient of pressure
    tmpRot = ([panels.xc; panels.yc]'*rot);
    panels.xRot = tmpRot(1);
    panels.yRot = tmpRot(2);
end

