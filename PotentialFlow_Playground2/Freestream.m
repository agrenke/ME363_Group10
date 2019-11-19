function [freestream] = Freestream(uInf,alpha)
%FREESTREAM quick function that sets the freestream velocity / AoA
%   Input alpha = DEGREES!

    freestream.uInf = uInf;
    freestream.alpha = deg2rad(alpha);

end

