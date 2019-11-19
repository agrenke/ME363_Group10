function [b] = buildFreeStream(panels, freestream)
%BUILDFREESTREAM assembles the vector "b" that is driven by
%   the far field conditions

b = zeros([length(panels)+1,1]);
    for i = 1:length(panels)
        b(i) = -freestream.uInf * cos(freestream.alpha - panels(i).beta);
    end
b(end) = -freestream.uInf * (sin(freestream.alpha - panels(1).beta)+ ...
    sin(freestream.alpha - panels(end).beta));    
    